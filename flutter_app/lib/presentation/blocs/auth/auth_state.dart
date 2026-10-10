import 'package:equatable/equatable.dart';

import '../../../domain/entities/user_entity.dart';

/// States emitted by [AuthCubit].
sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => const [];
}

/// Cold start: restoring the persisted Firebase session.
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Nobody is signed in — the router shows the Login screen.
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// A user is signed in.
class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.user) : super();

  final UserEntity user;

  @override
  List<Object?> get props => [user];
}

/// A request is in flight (button shows a spinner, inputs are disabled).
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Sign-up succeeded but the confirmation dialog has not been dismissed yet.
class AuthSignUpSuccess extends AuthState {
  const AuthSignUpSuccess(this.user) : super();

  final UserEntity user;

  @override
  List<Object?> get props => [user];
}

/// Something failed. [messageKey] is resolved through the ARB files by the UI.
class AuthFailureState extends AuthState {
  const AuthFailureState(this.messageKey, {this.fieldErrors = const {}});

  final String messageKey;

  /// Field name -> ARB key, used to paint per-input errors.
  final Map<String, String> fieldErrors;

  @override
  List<Object?> get props => [messageKey, fieldErrors];
}
