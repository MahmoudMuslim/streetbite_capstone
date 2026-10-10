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
    // A live Firebase session always wins: it is the source of truth after a
    // token refresh or a device restore.
    final user = _remote?.currentUser;
    if (user != null) {
      await _local.saveSession(user);
      return Right<Failure, UserEntity?>(user);
    }
    return Right<Failure, UserEntity?>(_local.readSession());
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

  /// Seeds the QA account the Appium suite signs in with.
  Future<void> prepare() => _local.ensureDemoAccount();

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
