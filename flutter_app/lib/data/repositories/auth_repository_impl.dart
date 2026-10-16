import '../../core/constants/app_constants.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../core/error/either.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

/// Coordinates Firebase Auth with the on-device fallback store.
///
/// Resilience strategy
/// -------------------
/// StreetBite is built so it never dead-ends on a Firebase outage:
///
/// 1. Try Firebase.
/// 2. On a *credential* error (wrong password, e-mail in use, ...) the error
///    is surfaced verbatim — the fallback must never mask a real rejection,
///    otherwise QA would never see Firebase's messages.
/// 3. On a *connectivity / configuration* error (`network-request-failed`,
///    SDK not initialised, ...) the request is retried against
///    [AuthLocalDataSource], so sign-up, login and session restore keep
///    working on a device without Google Play Services.
///
/// Step 2 vs step 3 is what stops the Appium suite from producing false
/// passes on a machine that simply has no network.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource this._remote,
    required this._local,
  });

  final AuthRemoteDataSource? _remote;
  final AuthLocalDataSource _local;

  bool get _firebaseUsable =>
      _remote != null && AppConstants.allowOfflineFirebaseFallback;

  @override
  Future<Either<Failure, UserEntity?>> restoreSession() async {
    // When Firebase is usable it is the **only** authority on whether anyone is
    // signed in.
    //
    // Falling back to the local store while Firebase is healthy produced a
    // "zombie session": the UI showed a signed-in Home screen while the backend
    // had no session at all, so every Firestore read came back
    // `PERMISSION_DENIED` and favourites and orders rendered an error the user
    // could not clear. A local cache is a convenience for offline use, never a
    // substitute for an authentication decision.
    if (_firebaseUsable) {
      await _refreshToken();
      return Right<Failure, UserEntity?>(_remote?.currentUser);
    }

    // Offline / no Play Services: the local session is all there is.
    return Right<Failure, UserEntity?>(_local.readSession());
  }

  /// Forces a fresh ID token before any Firestore read happens.
  ///
  /// This is not a theoretical nicety. After the app is killed and relaunched,
  /// `currentUser` is populated from disk while its cached ID token may be
  /// expired. Firestore then attaches that expired token to its first request
  /// and the server answers `PERMISSION_DENIED: Missing or insufficient
  /// permissions` — which looks exactly like broken security rules, and is not.
  ///
  /// The symptom was maddeningly stateful: a *fresh sign-in* worked, because
  /// login mints a valid token, while every *restored* session failed to load
  /// favourites and orders. The rules were fine the whole time.
  ///
  /// Failures are swallowed on purpose: an offline device should still open the
  /// app, and the reads will then be served from Firestore's local cache or
  /// retry once connectivity returns.
  Future<void> _refreshToken() async {
    if (_remote == null) return;
    try {
      await _remote.refreshIdToken();
    } catch (_) {
      // Offline or the refresh raced a sign-out; not fatal.
    }
  }

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    if (_firebaseUsable) {
      try {
        final user = await _remote!.login(email: email, password: password);
        await _local.saveSession(user);
        return Right<Failure, UserEntity>(user);
      } on AuthFailure catch (failure) {
        // Credential-level rejections are real: show them, do not fall back.
        if (!_isConnectivityFailure(failure.messageKey)) {
          return Left<Failure, UserEntity>(failure);
        }
      }
    }
    return _loginLocally(email: email, password: password);
  }

  @override
  Future<Either<Failure, UserEntity>> signUp({
    required String displayName,
    required String email,
    required String password,
  }) async {
    if (_firebaseUsable) {
      try {
        final user = await _remote!.signUp(
          email: email,
          password: password,
          displayName: displayName,
        );
        await _local.saveSession(user);
        return Right<Failure, UserEntity>(user);
      } on AuthFailure catch (failure) {
        if (!_isConnectivityFailure(failure.messageKey)) {
          return Left<Failure, UserEntity>(failure);
        }
      }
    }

    if (_local.findByEmail(email) != null) {
      return const Left<Failure, UserEntity>(
        AuthFailure('authErrorEmailInUse'),
      );
    }

    try {
      final user = await _local.createUser(
        email: email,
        password: password,
        displayName: displayName,
      );
      await _local.saveSession(user);
      return Right<Failure, UserEntity>(user);
    } catch (_) {
      return const Left<Failure, UserEntity>(AuthFailure('authErrorUnknown'));
    }
  }

  @override
  Future<void> logout() async {
    await _remote?.logout();
    await _local.clearSession();
  }

  @override
  Stream<UserEntity?> authStateChanges() {
    final remote = _remote;
    if (remote == null) return Stream<UserEntity?>.value(null);
    return remote.authStateChanges();
  }

  // ---------------------------------------------------------------------------

  Future<Either<Failure, UserEntity>> _loginLocally({
    required String email,
    required String password,
  }) async {
    final user = _local.verifyCredentials(email: email, password: password);
    if (user == null) {
      return const Left<Failure, UserEntity>(
        AuthFailure('authErrorWrongPassword'),
      );
    }
    await _local.saveSession(user);
    return Right<Failure, UserEntity>(user);
  }

  /// Only connectivity-style failures justify the local fallback.
  bool _isConnectivityFailure(String messageKey) =>
      messageKey == 'authErrorNetwork' || messageKey == 'authErrorUnknown';
}
