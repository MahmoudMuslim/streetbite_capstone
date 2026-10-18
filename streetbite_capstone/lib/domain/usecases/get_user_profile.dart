import '../../core/error/failures.dart';
import '../../core/usecase/usecase.dart';
import '../entities/user_entity.dart';
import '../../core/error/either.dart';
import '../repositories/profile_repository.dart';

/// Reads the Firestore profile document for [uid], or `null` when absent.
class GetUserProfile implements UseCase<Either<Failure, UserEntity?>, String> {
  const GetUserProfile(this._repository);

  final ProfileRepository _repository;

  @override
  Future<Either<Failure, UserEntity?>> call(String uid) =>
      _repository.getProfile(uid);
}
