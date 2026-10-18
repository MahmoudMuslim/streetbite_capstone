import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streetbite_capstone/core/constants/app_routes.dart';
import 'package:streetbite_capstone/core/theme/app_theme.dart';
import 'package:streetbite_capstone/domain/entities/order_entity.dart';
import 'package:streetbite_capstone/domain/entities/payment.dart';
import 'package:streetbite_capstone/domain/entities/user_entity.dart';
import 'package:streetbite_capstone/domain/repositories/order_repository.dart';
import 'package:streetbite_capstone/domain/usecases/add_to_cart.dart';
import 'package:streetbite_capstone/domain/usecases/calculate_order_totals.dart';
import 'package:streetbite_capstone/domain/usecases/place_order.dart';
import 'package:streetbite_capstone/domain/usecases/remove_from_cart.dart';
import 'package:streetbite_capstone/l10n/generated/app_localizations.dart';
import 'package:streetbite_capstone/presentation/blocs/cart/cart_bloc.dart';
import 'package:streetbite_capstone/presentation/blocs/cart/cart_state.dart';
import 'package:streetbite_capstone/presentation/blocs/theme/theme_cubit.dart';
import 'package:streetbite_capstone/presentation/screens/orders/order_details_screen.dart';

import '../helpers/test_fixtures.dart';

class MockOrderRepository extends Mock implements OrderRepository {}

class FakeUserEntity extends Fake implements UserEntity {}

class FakeOrderEntity extends Fake implements OrderEntity {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues(<String, Object>{});

  setUpAll(() {
    registerFallbackValue(FakeUserEntity());
    registerFallbackValue(FakeOrderEntity());
  });

  /// Koshari x2 + Foul x1 = `$31.00`, which clears the free-delivery threshold,
  /// so this fixture exercises the "Free" fee row as well as the itemised lines.
  final order = TestFixtures.order();

  /// Pumps the receipt inside a harness that mirrors production: the global
  /// theme cubit, the app-wide cart bloc, the app theme and the localisations.
  ///
  /// As in `cart_line_action_test.dart`, the bloc is built *here* rather than in
  /// `setUp` — a bloc born in the root event loop never gets its stream flushed
  /// by `pumpAndSettle`, so a reorder would look like it did nothing.
  Future<CartBloc> pump(
    WidgetTester tester, {
    Locale locale = const Locale('en'),
    OrderEntity? shown,
  }) async {
    final themeCubit = ThemeCubit(await SharedPreferences.getInstance());
    final cart = CartBloc(
      addToCart: const AddToCart(),
      removeFromCart: const RemoveFromCart(),
      calculateTotals: const CalculateOrderTotals(),
      placeOrder: PlaceOrder(MockOrderRepository()),
    );
    addTearDown(() async {
      await themeCubit.close();
      await cart.close();
    });

    // A phone-shaped viewport, deliberately *taller* than the receipt: the list
    // is lazy, so at the default 800x600 test size the payment panel and the
    // reorder button would never be built and every assertion below the fold
    // would fail for the wrong reason.
    await tester.binding.setSurfaceSize(const Size(420, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<ThemeCubit>.value(value: themeCubit),
          BlocProvider<CartBloc>.value(value: cart),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          locale: locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          onGenerateRoute: (settings) => MaterialPageRoute<dynamic>(
            settings: settings,
            builder: (_) =>
                Scaffold(body: Center(child: Text('route:${settings.name}'))),
          ),
          home: OrderDetailsScreen(order: shown ?? order),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return cart;
  }

  testWidgets('the receipt shows the reference, the lines and the money', (
    tester,
  ) async {
    await pump(tester);

    expect(tester.takeException(), isNull);
    expect(find.text('Order details'), findsOneWidget);
    // The reference is wrapped in first-strong-isolate / pop-directional-isolate
    // so the `sb-…` id keeps its own left-to-right order under Arabic.
    expect(find.text('Order \u2066sb-1001\u2069'), findsOneWidget);
    expect(find.text('Delivered'), findsOneWidget);

    expect(find.text('Koshari'), findsOneWidget);
    expect(find.text('Foul Medames'), findsOneWidget);
    // Unit price and quantity are one muted line per row.
    expect(find.text('\$12.50 · × 2'), findsOneWidget);
    expect(find.text('\$6.00 · × 1'), findsOneWidget);

    expect(find.text('\$31.00'), findsWidgets); // subtotal *and* Koshari line
    expect(find.text('Free'), findsOneWidget); // fee waived above the threshold
    expect(find.text('\$1.49'), findsOneWidget);
    expect(
      find.text('\$32.49'),
      findsWidgets,
    ); // header summary *and* total row
  });

  testWidgets('the payment row is written by the strategy itself', (
    tester,
  ) async {
    await pump(tester);

    // `CardPayment.receiptLine` owns the masked digits, so the screen never
    // formats payment text itself.
    expect(find.byKey(const ValueKey('order_details_payment')), findsOneWidget);
    expect(find.text('Card ····4242'), findsOneWidget);
    expect(find.text('Visa / Mastercard ending in 4242.'), findsOneWidget);
  });

  testWidgets('a cash order reads differently from a card one', (tester) async {
    await pump(
      tester,
      shown: TestFixtures.order(id: 'sb-2', payment: const CashPayment()),
    );

    expect(find.text('Cash'), findsOneWidget);
    expect(
      find.text('Pay the vendor in cash when your order arrives.'),
      findsOneWidget,
    );
  });

  testWidgets('an active order is labelled as still being prepared', (
    tester,
  ) async {
    await pump(tester, shown: TestFixtures.order(status: OrderStatus.active));

    expect(tester.takeException(), isNull);
    expect(find.text('Being prepared'), findsOneWidget);
    expect(find.text('Delivered'), findsNothing);
  });

  testWidgets('Reorder replays every line into the cart and opens it', (
    tester,
  ) async {
    final cart = await pump(tester);

    await tester.tap(find.byKey(const ValueKey('reorder_button')));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(cart.state, isA<CartUpdated>());
    expect((cart.state as CartUpdated).itemCount, order.itemCount);
    expect(find.text('This order is back in your cart'), findsOneWidget);
    expect(find.text('route:${AppRoutes.cart}'), findsOneWidget);
  });

  testWidgets('a line opens the meal it belongs to', (tester) async {
    await pump(tester);

    await tester.tap(find.text('Foul Medames'));
    await tester.pumpAndSettle();

    expect(find.text('route:${AppRoutes.mealDetails}'), findsOneWidget);
  });

  testWidgets('the receipt renders in Arabic, dates included', (tester) async {
    await pump(tester, locale: const Locale('ar'));

    // An uninitialised intl locale throws right here, which is the point of
    // asserting the Arabic pass in a test instead of only on a device.
    expect(tester.takeException(), isNull);
    expect(find.text('تفاصيل الطلب'), findsOneWidget);
    expect(find.text('تم التسليم'), findsOneWidget);
    expect(find.text('الأصناف'), findsOneWidget);
    expect(find.text('إعادة الطلب'), findsOneWidget);
    expect(find.text('Koshari'), findsOneWidget);
  });

  testWidgets('a receipt with no lines falls back to the empty state', (
    tester,
  ) async {
    await pump(tester, shown: TestFixtures.order(items: const []));

    expect(tester.takeException(), isNull);
    expect(find.text('No orders yet'), findsOneWidget);
    expect(find.byKey(const ValueKey('reorder_button')), findsNothing);
  });
}
