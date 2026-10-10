import 'package:equatable/equatable.dart';

import 'meal_entity.dart';

/// One line in the cart: a meal plus how many times it was added.
class CartItemEntity extends Equatable {
  const CartItemEntity({required this.meal, required this.quantity});

  final MealEntity meal;
  final int quantity;

  double get lineTotal => meal.price * quantity;

  CartItemEntity copyWith({int? quantity}) =>
      CartItemEntity(meal: meal, quantity: quantity ?? this.quantity);

  @override
  List<Object?> get props => [meal, quantity];
}
