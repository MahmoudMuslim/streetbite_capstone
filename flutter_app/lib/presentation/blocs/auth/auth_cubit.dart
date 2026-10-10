import 'package:bloc/bloc.dart';

import '../../../core/error/failures.dart';
import '../../../core/usecase/usecase.dart';
import '../../../domain/entities/user_entity.dart';
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
  }) : super(const AuthInitial());

  final RestoreSession _restoreSession;
  final LoginUser _loginUser;
  final SignUpUser _signUpUser;
  final LogoutUser _logoutUser;

  /// Restores the persisted session on launch.
  ///
  /// Failure here is **not** fatal: a device that cannot reach Firebase simply
  /// lands on the Login screen, which is the correct user-visible outcome.
  Future<void> restore() async {
    final result = await _restoreSession(const NoParams());
    result.fold(
      (failure) => emit(const AuthUnauthenticated()),
      (user) => emit(
        user == null ? const AuthUnauthenticated() : AuthAuthenticated(user),
      ),
    );
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

  /// Maps a thrown [Failure] that escaped a use case into a UI state.
  ///
  /// Nothing should reach this, but having it guarantees the "no unhandled
  /// exception" promise even if a future use case throws unexpectedly.
  void reportUnexpected(Failure failure) =>
      emit(AuthFailureState(failure.messageKey));
}
