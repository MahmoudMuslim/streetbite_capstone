import '../../core/usecase/usecase.dart';
import '../entities/cart_item_entity.dart';
import '../entities/meal_entity.dart';

/// Adds a meal to the cart, or increments it when already present.
///
/// The cart is client-side state, so this use case is deliberately
/// synchronous and side-effect free: the `CartBloc` keeps the current items,
/// hands them in, and receives the next immutable list back. That makes the
/// whole cart behaviour unit-testable without a Bloc, Firebase or a widget.
class AddToCart implements SyncUseCase<List<CartItemEntity>, AddToCartParams> {
  const AddToCart();

  @override
  List<CartItemEntity> call(AddToCartParams params) {
    final items = List<CartItemEntity>.of(params.currentItems);

    final index = items.indexWhere((item) => item.meal.id == params.meal.id);
    if (index == -1) {
      items.add(CartItemEntity(meal: params.meal, quantity: 1));
    } else {
      items[index] = items[index].copyWith(quantity: items[index].quantity + 1);
    }
    return items;
  }
}

/// Parameters for [AddToCart].
class AddToCartParams extends Params {
  const AddToCartParams({required this.currentItems, required this.meal});

  final List<CartItemEntity> currentItems;
  final MealEntity meal;

  @override
  List<Object?> get props => [currentItems, meal];
}
