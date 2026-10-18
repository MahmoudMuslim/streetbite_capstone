import 'package:bloc/bloc.dart';

import '../../../core/usecase/usecase.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/get_biometric_sign_in.dart';
import '../../../domain/usecases/login_user.dart';
import '../../../domain/usecases/logout_user.dart';
import '../../../domain/usecases/restore_session.dart';
import '../../../domain/usecases/signup_user.dart';
import 'auth_state.dart';

/// Owns **all** authentication state for the app.
///
/// A Cubit (rather than a full Bloc) is used deliberately: authentication is a
/// simple, strictly-sequential state machine — restore, then either login or
/// sign-up, then logout — with no concurrent event streams and no need for
/// transformers, debouncing or event replay. Using a Bloc there would add
/// ceremony without adding capability. The meals feed and the cart, which do
/// have concurrent, event-sourced behaviour, use full BLoCs instead.
///
/// This is also the single place where `UserEntity` becomes known to the UI —
/// screens read it, they never fetch it themselves.
class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required this._restoreSession,
    required this._loginUser,
    required this._signUpUser,
    required this._logoutUser,
    required this._biometricSignIn,
  }) : super(const AuthInitial());

  final RestoreSession _restoreSession;
  final LoginUser _loginUser;
  final SignUpUser _signUpUser;
  final LogoutUser _logoutUser;
  final GetBiometricSignIn _biometricSignIn;

  /// Restores the persisted session on launch.
  ///
  /// Failure here is **not** fatal: a device that cannot reach Firebase simply
  /// lands on the Login screen, which is the correct user-visible outcome.
  Future<void> restore() async {
    final result = await _restoreSession(const NoParams());
    result.fold((failure) => emit(const AuthUnauthenticated()), (user) {
      if (user == null) {
        emit(const AuthUnauthenticated());
        return;
      }

      // With the opt-in on, a live session is only a *candidate* for
      // sign-in. Emitting AuthAuthenticated here instead would have made the
      // fingerprint a decorative prompt on a screen the user had already
      // passed.
      emit(
        _biometricSignIn(const NoParams())
            ? AuthBiometricGate(user)
            : AuthAuthenticated(user),
      );
    });
  }

  /// The scan passed, so the restored session is now honoured.
  void confirmBiometricSignIn() {
    final current = state;
    if (current is AuthBiometricGate) emit(AuthAuthenticated(current.user));
  }

  /// The scan was cancelled, failed, or the hardware went away.
  ///
  /// Deliberately **not** a sign-out. The agreed policy is that skipping the
  /// scan drops the user onto the password form, and tearing down the Firebase
  /// session here would turn one mis-tap into a full re-login — the credentials
  /// are still valid, only the local check was declined.
  void fallBackToPassword() => emit(const AuthUnauthenticated());

  /// Re-opens the fingerprint gate from the password form.
  ///
  /// Returns `false` when there is nothing for a scan to unlock, which is the
  /// common case: biometric sign-in never replaces credentials, it only waves
  /// aside the password for a session this device already holds and was told to
  /// protect. A Login screen reached by signing out genuinely has no session, so
  /// the caller must say so rather than show a prompt that could never succeed.
  Future<bool> retryBiometricSignIn() async {
    emit(const AuthLoading());
    final result = await _restoreSession(const NoParams());
    final user = result.fold((_) => null, (user) => user);

    if (user == null || !_biometricSignIn(const NoParams())) {
      emit(const AuthUnauthenticated());
      return false;
    }

    emit(AuthBiometricGate(user));
    return true;
  }

  Future<void> login({required String email, required String password}) async {
    emit(const AuthLoading());
    final result = await _loginUser(
      LoginParams(email: email, password: password),
    );
    result.fold(
      (failure) => emit(AuthFailureState(failure.messageKey)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> signUp({
    required String displayName,
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());
    final result = await _signUpUser(
      SignUpParams(displayName: displayName, email: email, password: password),
    );
    result.fold(
      (failure) => emit(AuthFailureState(failure.messageKey)),
      (user) => emit(AuthSignUpSuccess(user)),
    );
  }

  /// Called by the UI once the sign-up dialog has been dismissed.
  void confirmSignUp(UserEntity user) => emit(AuthAuthenticated(user));

  Future<void> logout() async {
    await _logoutUser(const NoParams());
    emit(const AuthUnauthenticated());
  }

  /// Clears an error without changing the auth state (used on text input).
  void clearError() {
    if (state is AuthFailureState) emit(const AuthUnauthenticated());
  }
}
