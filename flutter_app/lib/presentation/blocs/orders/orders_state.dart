import 'package:equatable/equatable.dart';

import '../../../domain/entities/order_entity.dart';

/// States emitted by [OrdersCubit] for the Orders tab / profile history.
sealed class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object?> get props => const [];
}

class OrdersInitial extends OrdersState {
  const OrdersInitial();
}

class OrdersLoading extends OrdersState {
  const OrdersLoading();
}

class OrdersLoaded extends OrdersState {
  const OrdersLoaded(this.orders);

  final List<OrderEntity> orders;

  /// Split exactly like the Figma design: a "Current" block on top and a
  /// "Past" block underneath.
  List<OrderEntity> get active =>
      orders.where((order) => order.status == OrderStatus.active).toList();

  List<OrderEntity> get past =>
      orders.where((order) => order.status == OrderStatus.past).toList();

  @override
  List<Object?> get props => [orders];
}

class OrdersError extends OrdersState {
  const OrdersError(this.messageKey);

  final String messageKey;

  @override
  List<Object?> get props => [messageKey];
}
