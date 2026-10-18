import '../../domain/entities/favourite_entity.dart';
import 'meal_model.dart';

/// Firestore representation of a saved meal.
///
/// Favourites are stored as `users/{uid}/favourites/{mealId}` where the
/// document *is* the meal, plus a `savedAt` timestamp so the Profile screen
/// can sort "most recently hearted first" straight from the query.
class FavouriteModel {
  const FavouriteModel({required this.meal, required this.savedAt});

  static const String savedAtKey = 'savedAt';

  final MealModel meal;
  final DateTime savedAt;

  factory FavouriteModel.fromJson(Map<String, dynamic> json) => FavouriteModel(
    meal: MealModel.fromJson(json),
    savedAt:
        DateTime.tryParse(json[savedAtKey]?.toString() ?? '') ?? DateTime.now(),
  );

  factory FavouriteModel.fromEntity(FavouriteEntity entity) => FavouriteModel(
    meal: MealModel.fromEntity(entity.meal),
    savedAt: entity.savedAt,
  );

  /// Flattens the meal fields into the document root and stamps the time.
  Map<String, dynamic> toJson() => <String, dynamic>{
    ...meal.toJson(),
    savedAtKey: savedAt.toIso8601String(),
  };

  FavouriteEntity toEntity() => FavouriteEntity(meal: meal, savedAt: savedAt);
}
