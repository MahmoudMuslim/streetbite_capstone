import '../../../domain/entities/cart_item_entity.dart';
import '../blocs/cart/cart_state.dart';

/// Reads one meal's in-cart quantity out of a [CartState].
///
/// Cards ask for a single number instead of scanning `items` themselves, so the
/// "which states actually hold a cart" rule lives in exactly one place.
/// [CartFailure] keeps the items on purpose — a failed checkout leaves the cart
/// untouched — so its badges and steppers must keep counting too.
extension CartQuantity on CartState {
  int quantityOf(String mealId) {
    final items = switch (this) {
      CartUpdated(:final items) => items,
      CartFailure(:final items) => items,
      _ => const <CartItemEntity>[],
    };
    for (final item in items) {
      if (item.meal.id == mealId) return item.quantity;
    }
    return 0;
  }
}
