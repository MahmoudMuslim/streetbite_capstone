import '../../domain/entities/cart_item_entity.dart';
import 'meal_model.dart';

/// Firestore representation of a single cart line.
class CartItemModel {
  const CartItemModel({required this.meal, required this.quantity});

  static const String mealKey = 'meal';
  static const String quantityKey = 'quantity';

  final MealModel meal;
  final int quantity;

  factory CartItemModel.fromJson(Map<String, dynamic> json) => CartItemModel(
    meal: MealModel.fromJson(
      Map<String, dynamic>.from(json[mealKey] as Map? ?? const {}),
    ),
    quantity: (json[quantityKey] as num?)?.toInt() ?? 1,
  );

  factory CartItemModel.fromEntity(CartItemEntity entity) => CartItemModel(
    meal: MealModel.fromEntity(entity.meal),
    quantity: entity.quantity,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    mealKey: meal.toJson(),
    quantityKey: quantity,
  };
}
