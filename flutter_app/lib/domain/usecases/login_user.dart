import '../../core/error/failures.dart';
import '../../core/usecase/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';
import '../../core/error/either.dart';
import 'restore_session.dart' show LoginParams;

/// Signs an existing user in and surfaces Firebase's error message in the UI.
///
/// The empty-input guard lives here rather than in the widget so the same rule
/// applies to any future caller (deep link, biometric re-auth, Appium script).
class LoginUser implements UseCase<Either<Failure, UserEntity>, LoginParams> {
  const LoginUser(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, UserEntity>> call(LoginParams params) async {
    final email = params.email.trim();
    if (email.isEmpty || params.password.isEmpty) {
      return const Left<Failure, UserEntity>(
        ValidationFailure('validationEmailRequired'),
      );
    }
    return _repository.login(email: email, password: params.password);
  }
}
