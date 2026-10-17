import '../../core/error/either.dart';
import '../../core/error/failures.dart';
import '../entities/meal_entity.dart';

/// Contract for the live menu feed.
///
/// **Dependency inversion:** the presentation layer depends on this abstract
/// interface, never on `MealRepositoryImpl` or on Dio. The implementation in
/// the data layer additionally honours the **Factory pattern** — see
/// `MealRepositoryImpl.selectDataSource()` — to decide between the remote API
/// and the local cache at runtime.
abstract interface class MealRepository {
  /// Returns the full menu. Emits `CacheFailure` when there is neither a
  /// successful response nor a usable local copy.
  Future<Either<Failure, List<MealEntity>>> getMeals();

  /// Returns the five-item "Hot Offers" strip.
  Future<Either<Failure, List<MealEntity>>> getHotOffers();
}
