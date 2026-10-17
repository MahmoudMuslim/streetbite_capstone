import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:streetbite_capstone/core/constants/app_constants.dart';
import 'package:streetbite_capstone/core/error/either.dart';
import 'package:streetbite_capstone/core/error/failures.dart';
import 'package:streetbite_capstone/domain/entities/order_entity.dart';
import 'package:streetbite_capstone/domain/repositories/order_repository.dart';
import 'package:streetbite_capstone/domain/usecases/get_order_history.dart';
import 'package:streetbite_capstone/presentation/blocs/orders/orders_cubit.dart';
import 'package:streetbite_capstone/presentation/blocs/orders/orders_state.dart';

import '../helpers/test_fixtures.dart';

class MockOrderRepository extends Mock implements OrderRepository {}

const orderWindow = AppConstants.orderActiveWindow;

OrderEntity placed(Duration ago) => TestFixtures.order(
  placedAt: DateTime.now().subtract(ago),
  // What `CartBloc` actually writes at checkout.
  status: OrderStatus.active,
);

void main() {
  late MockOrderRepository repository;
  late OrdersCubit cubit;

  setUp(() {
    repository = MockOrderRepository();
    cubit = OrdersCubit(GetOrderHistory(repository));
  });

  tearDown(() => cubit.close());

  test('a checkout written as active still lands in Past once delivered', () async {
    // Every order Firestore holds was written with `status: active` by the cart
    // and nothing ever rewrites it, so the split is the only thing that can move
    // an order out of "Current".
    when(() => repository.getOrderHistory(any())).thenAnswer(
      (_) async => Right<Failure, List<OrderEntity>>([
        placed(const Duration(minutes: 2)),
        placed(orderWindow + const Duration(hours: 3)),
      ]),
    );

    await cubit.load('u1');

    final state = cubit.state as OrdersLoaded;
    expect(state.active.single.id, state.orders.first.id);
    expect(state.past.single.id, state.orders.last.id);
  });

  test('an empty history leaves both blocks empty', () async {
    when(() => repository.getOrderHistory(any()))
        .thenAnswer((_) async => const Right<Failure, List<OrderEntity>>([]));

    await cubit.load('u1');

    final state = cubit.state as OrdersLoaded;
    expect(state.active, isEmpty);
    expect(state.past, isEmpty);
  });
}
