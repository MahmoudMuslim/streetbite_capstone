import 'package:equatable/equatable.dart';

import '../../../domain/entities/cart_item_entity.dart';
import '../../../domain/usecases/calculate_order_totals.dart';

/// States emitted by [CartBloc].
sealed class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => const [];
}

/// Nothing in the cart yet.
class CartInitial extends CartState {
  const CartInitial();
}

/// Cart contents plus the derived money, ready for the UI.
class CartUpdated extends CartState {
  const CartUpdated({
    required this.items,
    required this.totals,
    this.lastAdded,
    this.lastRemoved,
    this.justEmptied = false,
  });

  final List<CartItemEntity> items;

  /// Produced by `CalculateOrderTotals` — never recomputed inside a widget.
  final OrderTotals totals;

  /// Set when the last transition was an *add*, so `BlocListener` can show the
  /// right SnackBar without re-deriving what changed.
  final String? lastAdded;

  /// Set when the last transition was a *remove*.
  final String? lastRemoved;

  /// `true` only on the transition from non-empty to empty.
  final bool justEmptied;

  int get itemCount => items.fold<int>(0, (sum, item) => sum + item.quantity);

  bool get isEmpty => items.isEmpty;

  @override
  List<Object?> get props => [
    items,
    totals,
    lastAdded,
    lastRemoved,
    justEmptied,
  ];
}

/// An order was persisted and the cart emptied in the same transition.
class CartOrderPlaced extends CartState {
  const CartOrderPlaced({required this.orderId});

  final String orderId;

  @override
  List<Object?> get props => [orderId];
}

/// Checkout failed — the cart is intentionally left untouched.
class CartFailure extends CartState {
  const CartFailure(
    this.messageKey, {
    required this.items,
    required this.totals,
  });

  final String messageKey;
  final List<CartItemEntity> items;
  final OrderTotals totals;

  @override
  List<Object?> get props => [messageKey, items, totals];
}
