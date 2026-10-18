import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:streetbite_capstone/core/constants/app_constants.dart';
import 'package:streetbite_capstone/core/error/either.dart';
import 'package:streetbite_capstone/core/error/failures.dart';
import 'package:streetbite_capstone/domain/entities/order_entity.dart';
import 'package:streetbite_capstone/domain/repositories/order_repository.dart';
import 'package:streetbite_capstone/domain/usecases/get_order_history.dart';

import '../helpers/test_fixtures.dart';

class MockOrderRepository extends Mock implements OrderRepository {}

void main() {
  const window = AppConstants.orderActiveWindow;

  OrderEntity placed(Duration ago, {OrderStatus status = OrderStatus.active}) =>
      TestFixtures.order(
        placedAt: DateTime.now().subtract(ago),
        status: status,
      );

  group('OrderEntity.statusAt', () {
    test('keeps a freshly prepared order active', () {
      final order = placed(window - const Duration(minutes: 5));

      expect(order.statusAt(DateTime.now()), OrderStatus.active);
    });

    test('moves an order to past once the delivery window elapsed', () {
      final order = placed(window + const Duration(minutes: 1));

      expect(order.statusAt(DateTime.now()), OrderStatus.past);
    });

    test('flips exactly on the window boundary', () {
      final order = placed(window);

      expect(order.statusAt(DateTime.now()), OrderStatus.past);
    });

    test('never resurrects an order the vendor already closed', () {
      final order = placed(
        const Duration(minutes: 1),
        status: OrderStatus.past,
      );

      expect(order.statusAt(DateTime.now()), OrderStatus.past);
    });

    test('treats a clock-skewed future timestamp as still being prepared', () {
      final order = placed(
        const Duration(minutes: -5),
        status: OrderStatus.active,
      );

      expect(order.statusAt(DateTime.now()), OrderStatus.active);
    });
  });

  group('GetOrderHistory', () {
    late MockOrderRepository repository;
    late GetOrderHistory getOrderHistory;

    setUp(() {
      repository = MockOrderRepository();
      getOrderHistory = GetOrderHistory(repository);
    });

    test('resolves every persisted status against the clock', () async {
      final orders = [
        placed(window + const Duration(days: 2)),
        placed(const Duration(minutes: 4)),
      ];
      when(() => repository.getOrderHistory(any())).thenAnswer(
        (_) async => Right<Failure, List<OrderEntity>>(List.of(orders)),
      );

      final result = await getOrderHistory('u1');

      expect(result.valueOrNull!.map((order) => order.status).toList(), const [
        OrderStatus.past,
        OrderStatus.active,
      ]);
    });

    test('keeps the receipt data of a resolved order intact', () async {
      final koshari = placed(const Duration(days: 3), status: OrderStatus.past);
      when(
        () => repository.getOrderHistory(any()),
      ).thenAnswer((_) async => Right<Failure, List<OrderEntity>>([koshari]));

      final resolved = (await getOrderHistory('u1')).valueOrNull!.single;

      expect(resolved.id, koshari.id);
      expect(resolved.placedAt, koshari.placedAt);
      expect(resolved.total, koshari.total);
      expect(resolved.items, koshari.items);
      expect(resolved.payment, koshari.payment);
    });

    test('passes a failure through without touching the branch', () async {
      when(() => repository.getOrderHistory(any())).thenAnswer(
        (_) async => const Left<Failure, List<OrderEntity>>(
          ServerFailure(details: 'unavailable'),
        ),
      );

      final result = await getOrderHistory('u1');

      expect(result.isLeft, isTrue);
      expect(result.valueOrNull, isNull);
    });
  });
}
