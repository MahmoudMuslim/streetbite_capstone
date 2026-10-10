import 'package:bloc/bloc.dart';

import '../../../domain/entities/cart_item_entity.dart';
import '../../../domain/entities/meal_entity.dart';
import '../../../domain/entities/order_entity.dart';
import '../../../domain/entities/payment.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/add_to_cart.dart';
import '../../../domain/usecases/calculate_order_totals.dart';
import '../../../domain/usecases/place_order.dart';
import '../../../domain/usecases/remove_from_cart.dart';
import 'cart_event.dart';
import 'cart_state.dart';

/// Owns the shopping cart and the checkout transaction.
///
/// Design notes
/// ------------
/// * Every mutation goes through a **use case** (`AddToCart`,
///   `RemoveFromCart`, `CalculateOrderTotals`, `PlaceOrder`). The Bloc only
///   orchestrates — it never contains arithmetic or branching rules, which is
///   exactly what makes it unit-testable with four mocked use cases.
/// * `BlocListener` on the UI reacts to [CartUpdated.justEmptied] to show the
///   "your cart is now empty" SnackBar, and to [CartUpdated.lastAdded] /
///   [lastRemoved] for the per-item messages. The Bloc stays pure state.
class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc({
    required this._addToCart,
    required this._removeFromCart,
    required this._calculateTotals,
    required this._placeOrder,
  }) : super(const CartInitial()) {
    on<CartItemAdded>(_onItemAdded);
    on<CartItemRemoved>(_onItemRemoved);
    on<CartItemQuantityChanged>(_onQuantityChanged);
    on<CartCleared>(_onCleared);
    on<CartCheckoutRequested>(_onCheckoutRequested);
  }

  final AddToCart _addToCart;
  final RemoveFromCart _removeFromCart;
  final CalculateOrderTotals _calculateTotals;
  final PlaceOrder _placeOrder;

  List<CartItemEntity> get _currentItems => switch (state) {
    CartUpdated(:final items) => items,
    CartFailure(:final items) => items,
    _ => const <CartItemEntity>[],
  };

  /// Item currently being added/removed, surfaced to the UI for SnackBars.
  String _nameOf(String mealId) {
    for (final item in _currentItems) {
      if (item.meal.id == mealId) return item.meal.name;
    }
    return '';
  }

  MealEntity? _mealOf(String mealId) {
    for (final item in _currentItems) {
      if (item.meal.id == mealId) return item.meal;
    }
    return null;
  }

  void _onItemAdded(CartItemAdded event, Emitter<CartState> emit) {
    final items = _addToCart(
      AddToCartParams(currentItems: _currentItems, meal: event.meal),
    );
    emit(_updated(items, added: event.meal.name));
  }

  void _onItemRemoved(CartItemRemoved event, Emitter<CartState> emit) {
    final name = _nameOf(event.mealId);
    final items = _removeFromCart(
      RemoveFromCartParams(currentItems: _currentItems, mealId: event.mealId),
    );
    emit(_updated(items, removed: name));
  }

  void _onQuantityChanged(
    CartItemQuantityChanged event,
    Emitter<CartState> emit,
  ) {
    // Reuse the two primitive use cases so quantity logic exists in exactly
    // one place instead of being re-implemented here.
    final meal = _mealOf(event.mealId);
    if (meal == null) return;

    var items = _currentItems;
    if (event.delta > 0) {
      for (var i = 0; i < event.delta; i++) {
        items = _addToCart(AddToCartParams(currentItems: items, meal: meal));
      }
      emit(_updated(items, added: meal.name));
    } else {
      final name = meal.name;
      for (var i = 0; i < -event.delta; i++) {
        items = _removeFromCart(
          RemoveFromCartParams(currentItems: items, mealId: event.mealId),
        );
      }
      emit(_updated(items, removed: name));
    }
  }

  void _onCleared(CartCleared event, Emitter<CartState> emit) {
    emit(
      CartUpdated(
        items: const [],
        totals: _calculateTotals(const CalculateOrderTotalsParams(items: [])),
        justEmptied: _currentItems.isNotEmpty,
      ),
    );
  }

  /// Checks out the current cart.
  ///
  /// Dispatched as an event (rather than exposed as a method) so every state
  /// transition in this Bloc goes through the framework's event pipeline —
  /// which is what lets `emit` be used here, and what makes checkout
  /// replayable in a unit test.
  Future<void> checkout({
    required UserEntity user,
    required PaymentMethod payment,
  }) async {
    add(CartCheckoutRequested(user: user, payment: payment));
  }

  // ---------------------------------------------------------------------------

  Future<void> _onCheckoutRequested(
    CartCheckoutRequested event,
    Emitter<CartState> emit,
  ) async {
    final items = _currentItems;
    if (items.isEmpty) return;

    final totals = _calculateTotals(CalculateOrderTotalsParams(items: items));
    final order = OrderEntity(
      id: 'sb-${DateTime.now().millisecondsSinceEpoch}',
      userId: event.user.uid,
      items: items,
      subtotal: totals.subtotal,
      deliveryFee: totals.deliveryFee,
      serviceFee: totals.serviceFee,
      payment: event.payment,
      placedAt: DateTime.now(),
      status: OrderStatus.active,
    );

    final result = await _placeOrder(
      PlaceOrderParams(user: event.user, order: order),
    );
    result.fold(
      (failure) =>
          emit(CartFailure(failure.messageKey, items: items, totals: totals)),
      (orderId) => emit(CartOrderPlaced(orderId: orderId)),
    );
  }

  // ---------------------------------------------------------------------------

  /// Builds the next state, deriving `justEmptied` by comparing against the
  /// previous item list — the Bloc, not the widget, owns that transition.
  CartUpdated _updated(
    List<CartItemEntity> items, {
    String? added,
    String? removed,
  }) {
    final wasEmpty = _currentItems.isEmpty;
    return CartUpdated(
      items: items,
      totals: _calculateTotals(CalculateOrderTotalsParams(items: items)),
      lastAdded: added,
      lastRemoved: removed,
      justEmptied: !wasEmpty && items.isEmpty,
    );
  }
}
