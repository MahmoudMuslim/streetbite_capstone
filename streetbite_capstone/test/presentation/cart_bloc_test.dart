import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:streetbite_capstone/core/error/either.dart';
import 'package:streetbite_capstone/core/error/failures.dart';
import 'package:streetbite_capstone/domain/entities/cart_item_entity.dart';
import 'package:streetbite_capstone/domain/entities/order_entity.dart';
import 'package:streetbite_capstone/domain/entities/payment.dart';
import 'package:streetbite_capstone/domain/entities/user_entity.dart';
import 'package:streetbite_capstone/domain/repositories/order_repository.dart';
import 'package:streetbite_capstone/domain/usecases/add_to_cart.dart';
import 'package:streetbite_capstone/domain/usecases/calculate_order_totals.dart';
import 'package:streetbite_capstone/domain/usecases/place_order.dart';
import 'package:streetbite_capstone/domain/usecases/remove_from_cart.dart';
import 'package:streetbite_capstone/presentation/blocs/cart/cart_bloc.dart';
import 'package:streetbite_capstone/presentation/blocs/cart/cart_event.dart';
import 'package:streetbite_capstone/presentation/blocs/cart/cart_state.dart';

import '../helpers/test_fixtures.dart';

class MockOrderRepository extends Mock implements OrderRepository {}

/// Registered with mocktail because `any(named: 'user')` needs a concrete
/// fallback instance of the non-nullable `UserEntity` type.
class FakeUserEntity extends Fake implements UserEntity {}

/// Likewise for the order aggregate.
class FakeOrderEntity extends Fake implements OrderEntity {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeUserEntity());
    registerFallbackValue(FakeOrderEntity());
  });

  late MockOrderRepository repository;

  const user = UserEntity(uid: 'u1', email: 'yasmine@streetbite.app');
  final meal = TestFixtures.meal(id: 'a', name: 'Koshari');

  CartBloc buildBloc() => CartBloc(
    addToCart: const AddToCart(),
    removeFromCart: const RemoveFromCart(),
    calculateTotals: const CalculateOrderTotals(),
    placeOrder: PlaceOrder(repository),
  );

  setUp(() {
    repository = MockOrderRepository();
    when(
      () => repository.placeOrder(
        user: any(named: 'user'),
        order: any(named: 'order'),
      ),
    ).thenAnswer((_) async => const Right<Failure, String>('order-1'));
  });

  blocTest<CartBloc, CartState>(
    'starts empty',
    build: buildBloc,
    verify: (bloc) => expect(bloc.state, isA<CartInitial>()),
  );

  blocTest<CartBloc, CartState>(
    'emits CartUpdated with one item after an add',
    build: buildBloc,
    act: (bloc) => bloc.add(CartItemAdded(meal)),
    verify: (bloc) {
      final state = bloc.state as CartUpdated;
      expect(state.items, hasLength(1));
      expect(state.itemCount, 1);
      expect(state.lastAdded, 'Koshari');
      expect(state.lastRemoved, isNull);
    },
  );

  blocTest<CartBloc, CartState>(
    'flags the transition to empty so the UI can show a SnackBar',
    build: buildBloc,
    act: (bloc) async {
      bloc.add(CartItemAdded(meal));
      await Future<void>.delayed(Duration.zero);
      bloc.add(CartItemRemoved('a'));
    },
    verify: (bloc) {
      final state = bloc.state as CartUpdated;
      expect(state.items, isEmpty);
      expect(state.justEmptied, isTrue);
      expect(state.lastRemoved, 'Koshari');
    },
  );

  blocTest<CartBloc, CartState>(
    'does not re-raise justEmptied when the cart was already empty',
    build: buildBloc,
    act: (bloc) => bloc.add(CartItemRemoved('unknown')),
    verify: (bloc) {
      final state = bloc.state as CartUpdated;
      expect(state.justEmptied, isFalse);
      expect(state.lastRemoved, '');
    },
  );

  blocTest<CartBloc, CartState>(
    'emits CartOrderPlaced after a successful checkout',
    build: buildBloc,
    seed: () => CartUpdated(
      items: [CartItemEntity(meal: meal, quantity: 1)],
      totals: const OrderTotals(
        subtotal: 12.5,
        deliveryFee: 2.49,
        serviceFee: 1.49,
        total: 16.48,
      ),
    ),
    act: (bloc) => bloc.checkout(user: user, payment: const CashPayment()),
    wait: const Duration(milliseconds: 50),
    verify: (bloc) {
      expect(bloc.state, isA<CartOrderPlaced>());
      verify(
        () => repository.placeOrder(
          user: user,
          order: any(named: 'order'),
        ),
      ).called(1);
    },
  );

  blocTest<CartBloc, CartState>(
    'keeps the cart intact when the checkout write fails',
    build: buildBloc,
    seed: () => CartUpdated(
      items: [CartItemEntity(meal: meal, quantity: 1)],
      totals: const OrderTotals(
        subtotal: 12.5,
        deliveryFee: 2.49,
        serviceFee: 1.49,
        total: 16.48,
      ),
    ),
    setUp: () {
      when(
        () => repository.placeOrder(
          user: any(named: 'user'),
          order: any(named: 'order'),
        ),
      ).thenAnswer((_) async => const Left(ServerFailure()));
    },
    act: (bloc) => bloc.checkout(user: user, payment: const CardPayment()),
    wait: const Duration(milliseconds: 50),
    verify: (bloc) {
      final state = bloc.state as CartFailure;
      expect(state.messageKey, 'failureNetwork');
      expect(state.items, hasLength(1), reason: 'items survive a failed write');
    },
  );

  blocTest<CartBloc, CartState>(
    'applies a negative quantity delta as a removal',
    build: buildBloc,
    seed: () => CartUpdated(
      items: [CartItemEntity(meal: meal, quantity: 2)],
      totals: const OrderTotals(
        subtotal: 25,
        deliveryFee: 0,
        serviceFee: 1.49,
        total: 26.49,
      ),
    ),
    act: (bloc) => bloc.add(const CartItemQuantityChanged('a', -1)),
    verify: (bloc) => expect((bloc.state as CartUpdated).itemCount, 1),
  );
}
