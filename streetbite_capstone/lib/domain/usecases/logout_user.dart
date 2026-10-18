import '../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

/// Clears the persistent session (Firebase sign-out + local cache wipe).
class LogoutUser implements UseCase<void, NoParams> {
  const LogoutUser(this._repository);

  final AuthRepository _repository;

  @override
  Future<void> call(NoParams params) => _repository.logout();
}
