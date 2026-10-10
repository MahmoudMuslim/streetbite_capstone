import '../../core/error/failures.dart';
import '../../core/usecase/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';
import '../../core/error/either.dart';
import 'restore_session.dart' show SignUpParams;

/// Creates an account and signs the new user straight in.
///
/// [SignUpParams.displayName] arrives already capitalised by the presentation
/// layer, which is what guarantees the Firestore profile is stored as
/// "First Last" and never "first last".
class SignUpUser implements UseCase<Either<Failure, UserEntity>, SignUpParams> {
  const SignUpUser(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, UserEntity>> call(SignUpParams params) {
    return _repository.signUp(
      displayName: params.displayName,
      email: params.email.trim(),
      password: params.password,
    );
  }
}
