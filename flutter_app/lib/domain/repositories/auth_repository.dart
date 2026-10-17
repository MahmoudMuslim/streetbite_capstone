import '../../core/error/failures.dart';
import '../entities/user_entity.dart';
import '../../core/error/either.dart';

/// Contract for authentication and the persisted session.
///
/// Implemented in the data layer on top of **Firebase Auth**, with a local
/// fallback so the app (and the Appium suite) still works on a device without
/// a reachable Firebase project.
abstract interface class AuthRepository {
  /// Emits the already-signed-in user restored from the persistent session, or
  /// `null` when there is none.
  Future<Either<Failure, UserEntity?>> restoreSession();

  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  });

  /// Creates the account, writes the profile document to Firestore, and signs
  /// the user in. [displayName] must already be capitalised by the caller.
  Future<Either<Failure, UserEntity>> signUp({
    required String displayName,
    required String email,
    required String password,
  });

  Future<void> logout();

  /// Whether a restored session must be confirmed by a biometric scan before
  /// the app honours it.
  ///
  /// Part of the auth contract rather than a settings detail because it changes
  /// what `restoreSession()` *means*: with the opt-in on, a live session is a
  /// candidate for sign-in, not sign-in itself.
  bool get biometricSignInEnabled;

  Future<void> setBiometricSignInEnabled({required bool enabled});

  /// Live stream of auth changes (used to keep the router in sync).
  Stream<UserEntity?> authStateChanges();
}
