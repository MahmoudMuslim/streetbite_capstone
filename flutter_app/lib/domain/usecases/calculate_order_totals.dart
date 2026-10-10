import '../../core/usecase/usecase.dart';
import '../entities/cart_item_entity.dart';

/// Computes the money shown on the Cart screen and stored with the order.
///
/// Keeping the fee arithmetic in a use case instead of inline in the widget
/// means the *same* numbers are produced for the UI, for the Firestore
/// document, and for the unit tests — no duplicated formula anywhere.
class CalculateOrderTotals
    implements SyncUseCase<OrderTotals, CalculateOrderTotalsParams> {
  const CalculateOrderTotals();

  /// Standard delivery fee applied to small baskets.
  static const double deliveryFee = 2.49;

  /// Flat service fee applied to every non-empty basket.
  static const double serviceFee = 1.49;

  /// Orders above this value ship free (surfaced in the UI as a promo hint).
  static const double freeDeliveryThreshold = 30.0;

  @override
  OrderTotals call(CalculateOrderTotalsParams params) {
    final subtotal = params.items.fold<double>(
      0,
      (sum, item) => sum + item.lineTotal,
    );

    // Empty basket -> no fees at all, so the total reads a clean "0.00".
    final deliveryFee =
        params.items.isEmpty || subtotal >= freeDeliveryThreshold
        ? 0.0
        : CalculateOrderTotals.deliveryFee;
    final serviceFee = params.items.isEmpty
        ? 0.0
        : CalculateOrderTotals.serviceFee;

    return OrderTotals(
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      serviceFee: serviceFee,
      total: subtotal + deliveryFee + serviceFee,
    );
  }
}

/// Immutable result of [CalculateOrderTotals].
class OrderTotals {
  const OrderTotals({
    required this.subtotal,
    required this.deliveryFee,
    required this.serviceFee,
    required this.total,
  });

  final double subtotal;
  final double deliveryFee;
  final double serviceFee;
  final double total;

  bool get hasFreeDelivery => deliveryFee == 0;
}

/// Parameters for [CalculateOrderTotals].
class CalculateOrderTotalsParams extends Params {
  const CalculateOrderTotalsParams({required this.items});

  final List<CartItemEntity> items;

  @override
  List<Object?> get props => [items];
}
