import '../../core/error/either.dart';
import '../../core/error/failures.dart';
import '../../core/usecase/usecase.dart';
import '../entities/meal_entity.dart';
import '../repositories/meal_repository.dart';

/// Loads the full menu feed for the Home screen grid.
///
/// The choice between the remote API and the local cache is **not** made here:
/// it is delegated to `MealRepositoryImpl` (Factory pattern), so the use case
/// stays a one-line description of *intent*.
class GetMeals implements UseCase<Either<Failure, List<MealEntity>>, NoParams> {
  const GetMeals(this._repository);

  final MealRepository _repository;

  @override
  Future<Either<Failure, List<MealEntity>>> call(NoParams params) =>
      _repository.getMeals();
}

/// Loads one meal for the Meal Details screen.
class GetMealById implements UseCase<Either<Failure, MealEntity?>, String> {
  const GetMealById(this._repository);

  final MealRepository _repository;

  @override
  Future<Either<Failure, MealEntity?>> call(String mealId) =>
      _repository.getMealById(mealId);
}

/// Loads the horizontal "Hot Offers" strip (five items).
class GetHotOffers
    implements UseCase<Either<Failure, List<MealEntity>>, NoParams> {
  const GetHotOffers(this._repository);

  final MealRepository _repository;

  @override
  Future<Either<Failure, List<MealEntity>>> call(NoParams params) =>
      _repository.getHotOffers();
}

/// Drops the cached menu payload (sign out, or an explicit forced refresh).
class ClearMealCache implements UseCase<void, NoParams> {
  const ClearMealCache(this._repository);

  final MealRepository _repository;

  @override
  Future<void> call(NoParams params) => _repository.clearCache();
}
