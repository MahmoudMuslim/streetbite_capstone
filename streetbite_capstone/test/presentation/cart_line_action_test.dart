import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:streetbite_capstone/core/theme/app_theme.dart';
import 'package:streetbite_capstone/domain/entities/order_entity.dart';
import 'package:streetbite_capstone/domain/entities/user_entity.dart';
import 'package:streetbite_capstone/domain/repositories/order_repository.dart';
import 'package:streetbite_capstone/domain/usecases/add_to_cart.dart';
import 'package:streetbite_capstone/domain/usecases/calculate_order_totals.dart';
import 'package:streetbite_capstone/domain/usecases/place_order.dart';
import 'package:streetbite_capstone/domain/usecases/remove_from_cart.dart';
import 'package:streetbite_capstone/l10n/generated/app_localizations.dart';
import 'package:streetbite_capstone/presentation/blocs/cart/cart_bloc.dart';
import 'package:streetbite_capstone/presentation/widgets/hot_offer_card.dart';
import 'package:streetbite_capstone/presentation/widgets/meal_card.dart';

import '../helpers/test_fixtures.dart';

class MockOrderRepository extends Mock implements OrderRepository {}

class FakeUserEntity extends Fake implements UserEntity {}

class FakeOrderEntity extends Fake implements OrderEntity {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeUserEntity());
    registerFallbackValue(FakeOrderEntity());
  });

  final meal = TestFixtures.meal(id: 'm1', name: 'Koshari');

  /// Pumps [child] at the size the Home grid gives a card and returns the bloc
  /// driving it.
  ///
  /// The bloc is deliberately built *here*, inside the test body: a `Bloc`
  /// created in `setUp` belongs to the root event loop, so its stream events
  /// are never flushed by `pumpAndSettle` and the card would appear frozen.
  Future<CartBloc> pump(WidgetTester tester, Widget child) async {
    final bloc = CartBloc(
      addToCart: const AddToCart(),
      removeFromCart: const RemoveFromCart(),
      calculateTotals: const CalculateOrderTotals(),
      placeOrder: PlaceOrder(MockOrderRepository()),
    );
    addTearDown(bloc.close);

    await tester.pumpWidget(
      BlocProvider<CartBloc>.value(
        value: bloc,
        child: MaterialApp(
          theme: AppTheme.light,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Scaffold(
            body: Center(
              child: SizedBox(width: 170, height: 218, child: child),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return bloc;
  }

  testWidgets('a card starts with a single add button', (tester) async {
    await pump(tester, MealCard(meal: meal, onTap: () {}));

    expect(tester.takeException(), isNull);
    expect(find.byIcon(Icons.add_rounded), findsOneWidget);
    expect(find.text('1'), findsNothing);
  });

  testWidgets('adding turns the button into the + count - stepper', (
    tester,
  ) async {
    final bloc = await pump(tester, MealCard(meal: meal, onTap: () {}));

    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    // The stepper in the footer and the badge over the artwork are two
    // separate renderings of the same number, so address them by key.
    expect(
      find.byKey(const ValueKey('cart_line_quantity_text_m1')),
      findsOneWidget,
    );
    expect(find.text('1'), findsNWidgets(2));
    expect(find.byKey(const ValueKey('cart_count_badge_m1')), findsOneWidget);
    expect(find.byIcon(Icons.remove_rounded), findsOneWidget);
    expect(bloc.state.toString(), contains('Koshari'));
  });

  testWidgets('the stepper steps down and back to a lone add button', (
    tester,
  ) async {
    await pump(tester, MealCard(meal: meal, onTap: () {}));

    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.remove_rounded));
    await tester.pumpAndSettle();

    expect(find.text('1'), findsNothing);
    expect(find.byKey(const ValueKey('cart_count_badge_m1')), findsNothing);
    // Back to the single affordance, so an empty line does not show a stepper.
    expect(find.byIcon(Icons.remove_rounded), findsNothing);
    expect(find.byIcon(Icons.add_rounded), findsOneWidget);
  });

  testWidgets('the hot offer strip card gets the same control', (tester) async {
    // The strip is the only place this card gets its height from, so the test
    // has to reproduce it — the card itself is flex-driven.
    await pump(
      tester,
      SizedBox(
        width: 156,
        height: 208,
        child: HotOfferCard(meal: meal, onTap: () {}, discountPercent: 10),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.byIcon(Icons.add_rounded), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(
      find.byKey(const ValueKey('cart_line_quantity_text_m1')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('cart_count_badge_m1')), findsOneWidget);
    expect(find.byIcon(Icons.remove_rounded), findsOneWidget);
  });
}
