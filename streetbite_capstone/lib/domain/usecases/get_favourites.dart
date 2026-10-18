import '../../core/error/failures.dart';
import '../../core/usecase/usecase.dart';
import '../entities/meal_entity.dart';
import '../repositories/favourite_repository.dart';
import '../../core/error/either.dart';

/// Loads every meal the signed-in user has hearted.
class GetFavourites
    implements UseCase<Either<Failure, List<MealEntity>>, String> {
  const GetFavourites(this._repository);

  final FavouriteRepository _repository;

  @override
  Future<Either<Failure, List<MealEntity>>> call(String uid) =>
      _repository.getFavourites(uid);
}
