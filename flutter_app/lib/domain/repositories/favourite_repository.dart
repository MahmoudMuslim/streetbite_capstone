import '../../core/error/failures.dart';
import '../../domain/entities/meal_entity.dart';
import '../../core/error/either.dart';

/// Contract for the per-user favourites sub-collection in Cloud Firestore.
abstract interface class FavouriteRepository {
  /// Adds the meal when absent, removes it when present.
  ///
  /// Returns `true` when the meal ended up **saved**, so the caller can show
  /// the matching SnackBar without a second round-trip.
  Future<Either<Failure, bool>> toggleFavourite({
    required String uid,
    required MealEntity meal,
  });

  /// The user's saved meals, newest first.
  Future<Either<Failure, List<MealEntity>>> getFavourites(String uid);
}
