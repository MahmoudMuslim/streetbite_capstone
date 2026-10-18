import '../../core/error/failures.dart';
import '../../core/usecase/usecase.dart';
import '../entities/meal_entity.dart';
import '../repositories/favourite_repository.dart';
import '../../core/error/either.dart';

/// Saves / removes a meal from the user's favourites in Cloud Firestore.
///
/// Returns `true` when the meal ended up **saved**, so the caller can show
/// the right SnackBar without a second round-trip.
class ToggleFavourite
    implements UseCase<Either<Failure, bool>, ToggleFavouriteParams> {
  const ToggleFavourite(this._repository);

  final FavouriteRepository _repository;

  @override
  Future<Either<Failure, bool>> call(ToggleFavouriteParams params) {
    if (params.uid.isEmpty) {
      return Future.value(
        const Left<Failure, bool>(ValidationFailure('failureGeneric')),
      );
    }
    return _repository.toggleFavourite(uid: params.uid, meal: params.meal);
  }
}

/// Parameters for [ToggleFavourite].
class ToggleFavouriteParams extends Params {
  const ToggleFavouriteParams({required this.uid, required this.meal});

  final String uid;
  final MealEntity meal;

  @override
  List<Object?> get props => [uid, meal];
}
