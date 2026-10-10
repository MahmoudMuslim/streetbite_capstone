import '../../core/error/failures.dart';
import '../../core/usecase/usecase.dart';
import '../entities/order_entity.dart';
import '../../core/error/either.dart';
import '../repositories/order_repository.dart';

/// Reads the signed-in user's order history, newest first.
class GetOrderHistory
    implements UseCase<Either<Failure, List<OrderEntity>>, String> {
  const GetOrderHistory(this._repository);

  final OrderRepository _repository;

  @override
  Future<Either<Failure, List<OrderEntity>>> call(String uid) =>
      _repository.getOrderHistory(uid);
}
