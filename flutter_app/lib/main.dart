import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import 'app.dart';
import 'core/theme/app_glass_theme.dart';
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

  // Shader pre-warm for the Liquid Glass theme. Purely async disk I/O, but a
  // device without a usable GPU can still throw here — and losing the glass
  // look must never cost the user the app, so it degrades instead of aborting.
  try {
    await LiquidGlassWidgets.initialize();
  } catch (error, stack) {
    debugPrint('StreetBite: liquid glass unavailable ($error)\n$stack');
  }

  // A partially wired container would make `sl<T>()` throw *inside* `runApp`,
  // which is the one place with no safety net. Checking here turns a crash
  // into a readable diagnostic screen.
  if (!_isGraphWired()) {
    runApp(const _StartupFailureApp());
    return;
  }

  runApp(
    // `wrap` installs the glass theme + adaptive-quality scope above
    // `MaterialApp`; `brightnessResolver` is what lets the glass follow the
    // in-app theme instead of the OS setting.
    LiquidGlassWidgets.wrap(
      brightnessResolver: Theme.maybeBrightnessOf,
      adaptiveQuality: true,
      theme: AppGlassTheme.data,
      child: StreetBiteApp(
        themeCubit: sl<ThemeCubit>(),
        localeCubit: sl<LocaleCubit>(),
        authCubit: sl<AuthCubit>(),
        mealsCubit: sl<MealsCubit>(),
        cartBloc: sl<CartBloc>(),
        favouritesCubit: sl<FavouritesCubit>(),
        ordersCubit: sl<OrdersCubit>(),
      ),
    ),
  );
}

/// `true` when every top-level dependency the widget tree needs is present.
bool _isGraphWired() {
  final required = <Type>[
    ThemeCubit,
    LocaleCubit,
    AuthCubit,
    MealsCubit,
    CartBloc,
    FavouritesCubit,
    OrdersCubit,
  ];
  return required.every((type) => sl.isRegistered(type: type));
}

/// Restores the persisted theme and language.
///
/// The QA account is seeded by the composition root (`injection.dart`), not
/// here: `main` only talks to abstractions, which keeps the dependency rule
/// `presentation → domain` intact.
Future<void> _prepareAppState() async {
  await sl<ThemeCubit>().load();
  await sl<LocaleCubit>().load();
}

/// Shown only when dependency injection could not complete.
///
/// Deliberately dependency-free (no cubits, no localisation) so it can render
/// even in a broken container, and it prints the exact fix on screen instead
/// of leaving the tester guessing.
class _StartupFailureApp extends StatelessWidget {
  const _StartupFailureApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  size: 56,
                  color: Color(0xFFE23D3D),
                ),
                const SizedBox(height: 20),
                const Text(
                  'StreetBite could not start',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 12),
                const Text(
                  'The dependency container was not fully built.\n'
                  'Run `flutter clean && flutter pub get`, then launch again.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
