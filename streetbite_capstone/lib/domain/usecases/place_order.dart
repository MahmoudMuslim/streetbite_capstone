import '../../core/error/failures.dart';
import '../../core/usecase/usecase.dart';
import '../entities/order_entity.dart';
import '../entities/user_entity.dart';
import '../../core/error/either.dart';
import '../repositories/order_repository.dart';

/// Persists the checkout to Cloud Firestore and returns the created order id.
///
/// The payment strategy is chosen by the caller and handed over as the
/// `PaymentMethod` abstraction, so this use case never knows whether the user
/// paid cash or by card (Open/closed principle).
class PlaceOrder implements UseCase<Either<Failure, String>, PlaceOrderParams> {
  const PlaceOrder(this._repository);

  final OrderRepository _repository;

  @override
  Future<Either<Failure, String>> call(PlaceOrderParams params) {
    if (params.order.items.isEmpty) {
      return Future<Either<Failure, String>>.value(
        const Left<Failure, String>(ValidationFailure('cartEmpty')),
      );
    }
    return _repository.placeOrder(user: params.user, order: params.order);
  }
}

/// Parameters for [PlaceOrder].
class PlaceOrderParams extends Params {
  const PlaceOrderParams({required this.user, required this.order});

  final UserEntity user;
  final OrderEntity order;

  @override
  List<Object?> get props => [user, order];
}
