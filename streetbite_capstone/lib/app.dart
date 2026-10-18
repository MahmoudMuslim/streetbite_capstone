import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'presentation/blocs/auth/auth_cubit.dart';
import 'presentation/blocs/cart/cart_bloc.dart';
import 'presentation/blocs/favourites/favourites_cubit.dart';
import 'presentation/blocs/locale/locale_cubit.dart';
import 'presentation/blocs/locale/locale_state.dart';
import 'presentation/blocs/meals/meals_cubit.dart';
import 'presentation/blocs/orders/orders_cubit.dart';
import 'presentation/blocs/theme/theme_cubit.dart';
import 'presentation/blocs/theme/theme_state.dart';
import 'core/constants/app_constants.dart';
import 'core/constants/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'l10n/generated/app_localizations.dart';
import 'presentation/router/app_router.dart';
import 'presentation/widgets/glass_backdrop.dart';

/// Root widget of StreetBite.
///
/// Provider placement explains the two runtime toggles:
///
/// * `ThemeCubit` and `LocaleCubit` are provided **above** `MaterialApp`
///   because they change its own configuration. Rebuilding `MaterialApp` with
///   a new `ThemeData` or a new `Locale` is what makes the dark-mode and
///   EN/AR switches work instantly, with no restart and no manual
///   `setState` anywhere in the app.
/// * The feature cubits (`Auth`, `Meals`, `Cart`, `Favourites`, `Orders`) are
///   also provided at the root. StreetBite deliberately shares them across
///   screens — the cart badge in the Home AppBar and the item list on the Cart
///   screen must read the *same* `CartBloc` instance, otherwise the badge and
///   the list can disagree for a frame.
///
/// The instances themselves are created once in `injection.dart` and are
/// long-lived, so `.value` is used (no widget owns their disposal).
class StreetBiteApp extends StatelessWidget {
  const StreetBiteApp({
    super.key,
    required this.themeCubit,
    required this.localeCubit,
    required this.authCubit,
    required this.mealsCubit,
    required this.cartBloc,
    required this.favouritesCubit,
    required this.ordersCubit,
  });

  final ThemeCubit themeCubit;
  final LocaleCubit localeCubit;
  final AuthCubit authCubit;
  final MealsCubit mealsCubit;
  final CartBloc cartBloc;
  final FavouritesCubit favouritesCubit;
  final OrdersCubit ordersCubit;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>.value(value: themeCubit),
        BlocProvider<LocaleCubit>.value(value: localeCubit),
        BlocProvider<AuthCubit>.value(value: authCubit),
        BlocProvider<MealsCubit>.value(value: mealsCubit),
        BlocProvider<CartBloc>.value(value: cartBloc),
        BlocProvider<FavouritesCubit>.value(value: favouritesCubit),
        BlocProvider<OrdersCubit>.value(value: ordersCubit),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return BlocBuilder<LocaleCubit, LocaleState>(
            builder: (context, localeState) {
              return MaterialApp(
                title: AppConstants.appName,
                debugShowCheckedModeBanner: false,
                // Glass exists in both brightnesses, so each slot swaps its own
                // glass object and `themeMode` keeps driving light/dark exactly
                // as it does for the Material themes.
                theme: themeState.isLiquidGlass
                    ? AppTheme.liquidGlassLight
                    : AppTheme.light,
                darkTheme: themeState.isLiquidGlass
                    ? AppTheme.liquidGlassDark
                    : AppTheme.dark,
                themeMode: themeState.themeMode,
                locale: localeState.locale,
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                // Sits above the Navigator, so every route — including pushed
                // ones — gets the aurora layer the glass surfaces refract.
                builder: (context, child) {
                  final route = child ?? const SizedBox.shrink();
                  return themeState.isLiquidGlass
                      ? GlassBackdrop(child: route)
                      : route;
                },
                onGenerateRoute: AppRouter.generate,
                initialRoute: AppRoutes.splash,
              );
            },
          );
        },
      ),
    );
  }
}
