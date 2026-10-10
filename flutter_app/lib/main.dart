import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'injection.dart';
import 'presentation/blocs/auth/auth_cubit.dart';
import 'presentation/blocs/cart/cart_bloc.dart';
import 'presentation/blocs/favourites/favourites_cubit.dart';
import 'presentation/blocs/locale/locale_cubit.dart';
import 'presentation/blocs/meals/meals_cubit.dart';
import 'presentation/blocs/orders/orders_cubit.dart';
import 'presentation/blocs/theme/theme_cubit.dart';

/// Application entry point.
///
/// The boot sequence is deliberately explicit:
///
/// 1. `WidgetsFlutterBinding.ensureInitialized()` — required before any plugin
///    call (`SharedPreferences`, Firebase, ...).
/// 2. `configureDependencies()` — builds the GetIt graph.
/// 3. Seed the on-device QA account and restore the saved theme/language.
/// 4. `runApp`.
///
/// Every step is wrapped so that a failure in (2) or (3) still produces a
/// running app rather than a black screen — the "no unhandled exceptions"
/// requirement applies to start-up too.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  try {
    await configureDependencies();
    await _prepareAppState();
  } catch (error, stack) {
    debugPrint('StreetBite: start-up degraded ($error)\n$stack');
  }

  runApp(
    StreetBiteApp(
      themeCubit: sl<ThemeCubit>(),
      localeCubit: sl<LocaleCubit>(),
      authCubit: sl<AuthCubit>(),
      mealsCubit: sl<MealsCubit>(),
      cartBloc: sl<CartBloc>(),
      favouritesCubit: sl<FavouritesCubit>(),
      ordersCubit: sl<OrdersCubit>(),
    ),
  );
}

/// Restores persisted preferences and seeds the QA account.
Future<void> _prepareAppState() async {
  await sl<ThemeCubit>().load();
  await sl<LocaleCubit>().load();

  // Creates the demo account the Appium suite signs in with. Idempotent, and a
  // failure here is harmless because the screen simply shows no account.
  await sl<AuthRepositoryImpl>().prepare();
}
