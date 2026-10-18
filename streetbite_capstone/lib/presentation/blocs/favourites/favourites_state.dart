import 'package:equatable/equatable.dart';

import '../../../domain/entities/meal_entity.dart';

/// States emitted by [FavouritesCubit].
sealed class FavouritesState extends Equatable {
  const FavouritesState();

  @override
  List<Object?> get props => const [];
}

/// Not loaded yet.
class FavouritesInitial extends FavouritesState {
  const FavouritesInitial();
}

class FavouritesLoading extends FavouritesState {
  const FavouritesLoading();
}

class FavouritesLoaded extends FavouritesState {
  const FavouritesLoaded(this.meals);

  final List<MealEntity> meals;

  /// Ids of saved meals — a `Set` lookup keeps the heart button O(1).
  Set<String> get ids => meals.map((meal) => meal.id).toSet();

  bool contains(String mealId) => ids.contains(mealId);

  @override
  List<Object?> get props => [meals];
}

class FavouritesError extends FavouritesState {
  const FavouritesError(this.messageKey);

  final String messageKey;

  @override
  List<Object?> get props => [messageKey];
}
