import 'package:equatable/equatable.dart';

import 'meal_entity.dart';

/// A meal the user has hearted, stored under
/// `users/{uid}/favourites/{mealId}` in Cloud Firestore.
class FavouriteEntity extends Equatable {
  const FavouriteEntity({required this.meal, required this.savedAt});

  final MealEntity meal;
  final DateTime savedAt;

  @override
  List<Object?> get props => [meal, savedAt];
}
