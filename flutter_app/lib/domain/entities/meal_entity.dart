import 'package:equatable/equatable.dart';

/// A single dish as shown on the home feed, the details screen and the cart.
///
/// This is a **domain entity**: pure Dart, no JSON, no Flutter. Serialisation
/// lives on `MealModel` (data layer) which extends this class.
class MealEntity extends Equatable {
  const MealEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.thumbnailUrl,
    required this.price,
    this.tags = const [],
    this.youtubeUrl,
  });

  /// TheMealDB identifier (also used as the Firestore document id).
  final String id;

  final String name;
  final String category;

  /// Country / region the dish originates from.
  final String area;
  final String instructions;
  final String thumbnailUrl;

  /// Price is *not* provided by TheMealDB; the data layer derives a stable
  /// price from the meal id so the cart total is consistent across launches.
  final double price;

  final List<String> tags;
  final String? youtubeUrl;

  @override
  List<Object?> get props => [
    id,
    name,
    category,
    area,
    instructions,
    thumbnailUrl,
    price,
    tags,
  ];
}
