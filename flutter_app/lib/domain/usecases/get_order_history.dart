import '../../core/error/failures.dart';
import '../../core/usecase/usecase.dart';
import '../entities/order_entity.dart';
import '../../core/error/either.dart';
import '../repositories/order_repository.dart';

/// Reads the signed-in user's order history, newest first.
///
/// The persisted status is resolved against the clock on the way out, so every
/// reader of a history list — the Orders tab, the Profile summary, a receipt —
/// sees the same lifecycle without any of them owning the rule.
class GetOrderHistory
    implements UseCase<Either<Failure, List<OrderEntity>>, String> {
  const GetOrderHistory(this._repository);

  final OrderRepository _repository;

  @override
  Future<Either<Failure, List<OrderEntity>>> call(String uid) async {
    final now = DateTime.now();
    final result = await _repository.getOrderHistory(uid);
    return result.map(
      (orders) => orders
          .map((order) => order.copyWith(status: order.statusAt(now)))
          .toList(),
    );
  }
}
