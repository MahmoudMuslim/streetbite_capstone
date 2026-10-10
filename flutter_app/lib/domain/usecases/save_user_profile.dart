import '../../core/error/failures.dart';
import '../../core/usecase/usecase.dart';
import '../entities/user_entity.dart';
import '../../core/error/either.dart';
import '../repositories/profile_repository.dart';

/// Creates or refreshes the Firestore profile document for [user].
///
/// Called right after a successful sign-up so `users/{uid}` always exists for
/// favourites, orders and the profile screen to hang off.
class SaveUserProfile implements UseCase<Either<Failure, void>, UserEntity> {
  const SaveUserProfile(this._repository);

  final ProfileRepository _repository;

  @override
  Future<Either<Failure, void>> call(UserEntity user) async {
    return _repository.saveProfile(user);
  }
}
