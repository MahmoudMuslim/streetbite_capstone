import '../../core/error/failures.dart';
import '../../core/usecase/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';
import '../../core/error/either.dart';

/// Credentials for [LoginUser].
class LoginParams extends Params {
  const LoginParams({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

/// Credentials for [SignUpUser].
class SignUpParams extends Params {
  const SignUpParams({
    required this.displayName,
    required this.email,
    required this.password,
  });

  /// Already normalised to "First Last" by the presentation layer.
  final String displayName;
  final String email;
  final String password;

  @override
  List<Object?> get props => [displayName, email, password];
}

/// Restores the persisted session on cold start.
///
/// Returning `null` instead of throwing when nobody is signed in is a valid
/// outcome — the router then simply shows the Login screen.
class RestoreSession
    implements UseCase<Either<Failure, UserEntity?>, NoParams> {
  const RestoreSession(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, UserEntity?>> call(NoParams params) =>
      _repository.restoreSession();
}
