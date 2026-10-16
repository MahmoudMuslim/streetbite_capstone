import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streetbite_capstone/core/error/either.dart';
import 'package:streetbite_capstone/core/error/failures.dart';
import 'package:streetbite_capstone/core/theme/app_theme.dart';
import 'package:streetbite_capstone/domain/entities/meal_entity.dart';
import 'package:streetbite_capstone/domain/entities/user_entity.dart';
import 'package:streetbite_capstone/domain/repositories/auth_repository.dart';
import 'package:streetbite_capstone/domain/repositories/favourite_repository.dart';
import 'package:streetbite_capstone/domain/repositories/order_repository.dart';
import 'package:streetbite_capstone/domain/usecases/add_to_cart.dart';
import 'package:streetbite_capstone/domain/usecases/calculate_order_totals.dart';
import 'package:streetbite_capstone/domain/usecases/get_favourites.dart';
import 'package:streetbite_capstone/domain/usecases/login_user.dart';
import 'package:streetbite_capstone/domain/usecases/logout_user.dart';
import 'package:streetbite_capstone/domain/usecases/place_order.dart';
import 'package:streetbite_capstone/domain/usecases/remove_from_cart.dart';
import 'package:streetbite_capstone/domain/usecases/restore_session.dart';
import 'package:streetbite_capstone/domain/usecases/signup_user.dart';
import 'package:streetbite_capstone/domain/usecases/toggle_favourite.dart';
import 'package:streetbite_capstone/l10n/generated/app_localizations.dart';
import 'package:streetbite_capstone/presentation/blocs/auth/auth_cubit.dart';
import 'package:streetbite_capstone/presentation/blocs/cart/cart_bloc.dart';
import 'package:streetbite_capstone/presentation/blocs/favourites/favourites_cubit.dart';
import 'package:streetbite_capstone/presentation/blocs/theme/theme_cubit.dart';
import 'package:streetbite_capstone/presentation/screens/home/meal_details_screen.dart';

import '../helpers/test_fixtures.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockFavouriteRepository extends Mock implements FavouriteRepository {}

class MockOrderRepository extends Mock implements OrderRepository {}

class FakeUserEntity extends Fake implements UserEntity {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues(<String, Object>{});

  setUpAll(() {
    registerFallbackValue(FakeUserEntity());
  });

  final meal = TestFixtures.meal(id: 'm1', name: 'Koshari');

  /// Pumps the details screen with the same global blocs production provides.
  Future<void> pump(WidgetTester tester) async {
    final authRepository = MockAuthRepository();
    final favouriteRepository = MockFavouriteRepository();
    when(() => favouriteRepository.getFavourites(any<String>())).thenAnswer(
      (_) async => const Right<Failure, List<MealEntity>>(<MealEntity>[]),
    );

    final themeCubit = ThemeCubit(await SharedPreferences.getInstance());
    final authCubit = AuthCubit(
      restoreSession: RestoreSession(authRepository),
      loginUser: LoginUser(authRepository),
      signUpUser: SignUpUser(authRepository),
      logoutUser: LogoutUser(authRepository),
    );
    final favouritesCubit = FavouritesCubit(
      getFavourites: GetFavourites(favouriteRepository),
      toggleFavourite: ToggleFavourite(favouriteRepository),
    );
    final cart = CartBloc(
      addToCart: const AddToCart(),
      removeFromCart: const RemoveFromCart(),
      calculateTotals: const CalculateOrderTotals(),
      placeOrder: PlaceOrder(MockOrderRepository()),
    );
    addTearDown(() async {
      await themeCubit.close();
      await authCubit.close();
      await favouritesCubit.close();
      await cart.close();
    });

    await tester.binding.setSurfaceSize(const Size(420, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<ThemeCubit>.value(value: themeCubit),
          BlocProvider<AuthCubit>.value(value: authCubit),
          BlocProvider<FavouritesCubit>.value(value: favouritesCubit),
          BlocProvider<CartBloc>.value(value: cart),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          locale: const Locale('en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: MealDetailsScreen(meal: meal),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('the details sheet paints its title, body and both actions', (
    tester,
  ) async {
    await pump(tester);

    expect(tester.takeException(), isNull);
    expect(find.text('Koshari'), findsOneWidget);
    expect(find.text('Instructions'), findsOneWidget);
    expect(find.text('Mix lentils, rice and pasta.'), findsOneWidget);

    // The action row: the circular heart and the cart CTA beside it.
    expect(find.byKey(const ValueKey('save_favourite_button')), findsOneWidget);
    expect(find.text('Add to cart'), findsOneWidget);

    // Everything the shopper has to reach is on screen, not off the edges.
    for (final finder in [
      find.text('Koshari'),
      find.byKey(const ValueKey('save_favourite_button')),
      find.text('Add to cart'),
    ]) {
      final rect = tester.getRect(finder);
      expect(rect.right, lessThanOrEqualTo(420));
      expect(rect.bottom, lessThanOrEqualTo(1600));
    }
  });
}
