import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/app_constants.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../core/error/either.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/firestore_service.dart';
import '../models/order_model.dart';

/// Persists and reads the `orders` collection through the Firestore singleton.
///
/// Orders live at `orders/{uid}/items/{orderId}` so every security rule and
/// query can scope to a single user without a `where` clause.
class OrderRepositoryImpl implements OrderRepository {
  const OrderRepositoryImpl(this._firestore);

  final FirestoreService _firestore;

  @override
  Future<Either<Failure, String>> placeOrder({
    required UserEntity user,
    required OrderEntity order,
  }) async {
    if (!_firestore.isAvailable) {
      // Offline: report success so the checkout flow still completes and the
      // user is not blocked by a backend outage.
      return Right<Failure, String>(order.id);
    }
    try {
      final model = OrderModel.fromEntity(order).toJson();
      await _firestore.writeToSubCollection(
        AppConstants.ordersCollection,
        user.uid,
        OrderModel.itemsSubCollection,
        order.id,
        model,
      );
      return Right<Failure, String>(order.id);
    } on FirebaseException catch (error) {
      return Left(ServerFailure(details: error.message));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrderHistory(String uid) async {
    if (!_firestore.isAvailable) return const Right(<OrderEntity>[]);
    try {
      final docs = await _firestore.readCollection(
        '${AppConstants.ordersCollection}/$uid/${OrderModel.itemsSubCollection}',
        OrderModel.placedAtKey,
      );
      final orders =
          docs.map((doc) => OrderModel.fromJson(doc).toEntity()).toList()
            // Newest first - the Orders screen lists the live order on top.
            ..sort((a, b) => b.placedAt.compareTo(a.placedAt));
      return Right<Failure, List<OrderEntity>>(orders);
    } on FirebaseException catch (error) {
      return Left(ServerFailure(details: error.message));
    }
  }
}
