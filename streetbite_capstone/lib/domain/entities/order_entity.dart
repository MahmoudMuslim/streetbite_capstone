import 'package:equatable/equatable.dart';

import '../../core/constants/app_constants.dart';
import 'cart_item_entity.dart';
import 'payment.dart';

/// A completed StreetBite order, persisted in Cloud Firestore.
///
/// The order stores its own immutable snapshot of the purchased meals so that
/// later price changes (or a deleted menu item) never rewrite history.
class OrderEntity extends Equatable {
  const OrderEntity({
    required this.id,
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.serviceFee,
    required this.payment,
    required this.placedAt,
    required this.status,
  });

  final String id;
  final String userId;
  final List<CartItemEntity> items;

  final double subtotal;
  final double deliveryFee;
  final double serviceFee;

  /// Payment strategy chosen at checkout (SOLID — see `payment.dart`).
  final PaymentMethod payment;

  final DateTime placedAt;

  /// `active` while the vendor is still preparing, `past` afterwards.
  final OrderStatus status;

  double get total => subtotal + deliveryFee + serviceFee;

  int get itemCount => items.fold<int>(0, (sum, item) => sum + item.quantity);

  /// The lifecycle this order has at [now].
  ///
  /// The stored [status] records what was true when checkout wrote the document;
  /// it is a snapshot, not a live claim. [OrderStatus.active] therefore only
  /// means "the vendor still had it in the kitchen at [placedAt]" for as long as
  /// [AppConstants.orderActiveWindow] covers, after which the delivery is over
  /// and the order belongs to `past`. Resolving it here rather than writing the
  /// new value back is deliberate: no client can mark an order delivered for a
  /// kitchen it cannot see, but every reader still gets the honest answer.
  OrderStatus statusAt(DateTime now) {
    if (status == OrderStatus.past) return OrderStatus.past;
    return now.difference(placedAt) < AppConstants.orderActiveWindow
        ? OrderStatus.active
        : OrderStatus.past;
  }

  OrderEntity copyWith({OrderStatus? status}) => OrderEntity(
    id: id,
    userId: userId,
    items: items,
    subtotal: subtotal,
    deliveryFee: deliveryFee,
    serviceFee: serviceFee,
    payment: payment,
    placedAt: placedAt,
    status: status ?? this.status,
  );

  @override
  List<Object?> get props => [
    id,
    userId,
    items,
    subtotal,
    deliveryFee,
    serviceFee,
    payment,
    placedAt,
    status,
  ];
}

/// Lifecycle of an order, mirrored to the two sections on the Orders screen.
enum OrderStatus {
  active('active'),
  past('past');

  const OrderStatus(this.key);

  final String key;

  static OrderStatus fromKey(String? key) => OrderStatus.values.firstWhere(
    (status) => status.key == key,
    orElse: () => OrderStatus.past,
  );
}
