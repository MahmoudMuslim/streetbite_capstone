import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_order_history.dart';
import 'orders_state.dart';

/// Loads the signed-in user's order history from Cloud Firestore.
///
/// Called both from the Orders tab and from the Profile screen; the repository
/// cache means the second call is free.
class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit(this._getOrderHistory) : super(const OrdersInitial());

  final GetOrderHistory _getOrderHistory;

  Future<void> load(String uid) async {
    if (uid.isEmpty) {
      emit(const OrdersLoaded([]));
      return;
    }
    emit(const OrdersLoading());
    final result = await _getOrderHistory(uid);
    result.fold(
      (failure) => emit(OrdersError(failure.messageKey)),
      (orders) => emit(OrdersLoaded(orders)),
    );
  }

  /// Re-reads the history after a checkout so the new order appears at once.
  Future<void> refresh(String uid) => load(uid);
}
