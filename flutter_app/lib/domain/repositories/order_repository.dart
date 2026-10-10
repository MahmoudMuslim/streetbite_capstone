import '../../core/error/failures.dart';
import '../../domain/entities/order_entity.dart';
import '../entities/user_entity.dart';
import '../../core/error/either.dart';

/// Contract for the orders collection in Cloud Firestore.
abstract interface class OrderRepository {
  /// Persists the order for [user] and returns the stored document id.
  Future<Either<Failure, String>> placeOrder({
    required UserEntity user,
    required OrderEntity order,
  });

  /// Every order for the user, newest first.
  Future<Either<Failure, List<OrderEntity>>> getOrderHistory(String uid);
}
