import '../../core/usecase/usecase.dart';
import '../entities/cart_item_entity.dart';

/// Removes one serving of a meal, dropping the whole line at zero.
///
/// Mirrors [AddToCart]: a pure function over the current item list, which the
/// `CartBloc` funnels through so there is exactly **one** place where cart
/// quantities are mutated.
class RemoveFromCart
    implements SyncUseCase<List<CartItemEntity>, RemoveFromCartParams> {
  const RemoveFromCart();

  @override
  List<CartItemEntity> call(RemoveFromCartParams params) {
    final items = List<CartItemEntity>.of(params.currentItems);

    final index = items.indexWhere((item) => item.meal.id == params.mealId);
    if (index == -1) return items;

    final nextQuantity = items[index].quantity - 1;
    if (nextQuantity <= 0) {
      items.removeAt(index);
    } else {
      items[index] = items[index].copyWith(quantity: nextQuantity);
    }
    return items;
  }
}

/// Parameters for [RemoveFromCart].
class RemoveFromCartParams extends Params {
  const RemoveFromCartParams({
    required this.currentItems,
    required this.mealId,
  });

  final List<CartItemEntity> currentItems;
  final String mealId;

  @override
  List<Object?> get props => [currentItems, mealId];
}
