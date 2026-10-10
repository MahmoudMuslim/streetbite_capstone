import '../../domain/entities/cart_item_entity.dart';
import '../../domain/entities/order_entity.dart';
import 'cart_item_model.dart';
import 'payment_model.dart';

/// Firestore representation of a placed order.
///
/// Nested documents (items, payment) are written inline with the order. That
/// keeps the read path for the Orders screen to a **single** query, which is
/// what makes the screen render from one stream instead of N+1 reads.
class OrderModel {
  const OrderModel({
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

  static const String idKey = 'id';
  static const String userIdKey = 'userId';
  static const String itemsKey = 'items';
  static const String subtotalKey = 'subtotal';
  static const String deliveryFeeKey = 'deliveryFee';
  static const String serviceFeeKey = 'serviceFee';
  static const String paymentKey = 'payment';
  static const String placedAtKey = 'placedAt';
  static const String statusKey = 'status';
  static const String totalKey = 'total';

  /// Sub-collection holding a single user's orders:
  /// `orders/{uid}/items/{orderId}`.
  static const String itemsSubCollection = 'items';

  final String id;
  final String userId;
  final List<CartItemModel> items;
  final double subtotal;
  final double deliveryFee;
  final double serviceFee;
  final PaymentModel payment;
  final DateTime placedAt;
  final OrderStatus status;

  double get total => subtotal + deliveryFee + serviceFee;

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
    id: (json[idKey] ?? '').toString(),
    userId: (json[userIdKey] ?? '').toString(),
    items: (json[itemsKey] as List? ?? const [])
        .whereType<Map>()
        .map((item) => CartItemModel.fromJson(Map<String, dynamic>.from(item)))
        .toList(),
    subtotal: (json[subtotalKey] as num?)?.toDouble() ?? 0,
    deliveryFee: (json[deliveryFeeKey] as num?)?.toDouble() ?? 0,
    serviceFee: (json[serviceFeeKey] as num?)?.toDouble() ?? 0,
    payment: PaymentModel.fromJson(
      Map<String, dynamic>.from(json[paymentKey] as Map? ?? const {}),
    ),
    placedAt:
        DateTime.tryParse(json[placedAtKey]?.toString() ?? '') ??
        DateTime.now(),
    status: OrderStatus.fromKey(json[statusKey]?.toString()),
  );

  factory OrderModel.fromEntity(OrderEntity entity) => OrderModel(
    id: entity.id,
    userId: entity.userId,
    items: entity.items.map(CartItemModel.fromEntity).toList(),
    subtotal: entity.subtotal,
    deliveryFee: entity.deliveryFee,
    serviceFee: entity.serviceFee,
    payment: PaymentModel.fromEntity(entity.payment),
    placedAt: entity.placedAt,
    status: entity.status,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    idKey: id,
    userIdKey: userId,
    itemsKey: items.map((item) => item.toJson()).toList(),
    subtotalKey: subtotal,
    deliveryFeeKey: deliveryFee,
    serviceFeeKey: serviceFee,
    paymentKey: payment.toJson(),
    placedAtKey: placedAt.toIso8601String(),
    statusKey: status.key,
    totalKey: total,
  };

  /// Widens the model into the domain entity the repositories expose.
  ///
  /// The reverse direction ([OrderModel.fromEntity]) happens at the write
  /// boundary, so the two directions never live in the same place.
  OrderEntity toEntity() => OrderEntity(
    id: id,
    userId: userId,
    items: items
        .map((item) => CartItemEntity(meal: item.meal, quantity: item.quantity))
        .toList(),
    subtotal: subtotal,
    deliveryFee: deliveryFee,
    serviceFee: serviceFee,
    payment: payment.toEntity(),
    placedAt: placedAt,
    status: status,
  );
}
