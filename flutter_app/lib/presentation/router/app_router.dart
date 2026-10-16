import 'package:flutter/material.dart';

import '../../core/constants/app_routes.dart';
import '../../domain/entities/meal_entity.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/cart/order_confirmation_screen.dart';
import '../screens/home/main_shell_screen.dart';
import '../screens/home/meal_details_screen.dart';
import '../screens/map/vendor_map_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/splash/splash_screen.dart';

/// Central `onGenerateRoute` implementation.
///
/// Route *names* live in `core/constants/app_routes.dart`; route *arguments*
/// are resolved by the `switch` below. Having exactly one switch means the app
/// can never contain a route name with no screen behind it — the navigation
/// graph is complete by construction.
class AppRouter {
  const AppRouter._();

  /// Signature required by `MaterialApp.onGenerateRoute`.
  static Route<dynamic> generate(RouteSettings settings) {
    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (_) => resolve(settings),
    );
  }

  /// Builds the page for [settings].
  ///
  /// `arguments` follows the Flutter contract: a zero-based index followed by
  /// the caller's arguments, e.g. `[mealEntity]` from `pushNamed`.
  static Widget resolve(RouteSettings settings) {
    final args = settings.arguments as List<Object?>? ?? const [];

    switch (settings.name) {
      case AppRoutes.splash:
        return const SplashScreen();

      case AppRoutes.login:
        return const LoginScreen();

      case AppRoutes.signUp:
        return const SignUpScreen();

      case AppRoutes.home:
        // An optional tab index travels as the first argument, so a caller can
        // rebuild the shell already sitting on Orders (see the checkout flow).
        return MainShellScreen(
          initialIndex: args.isNotEmpty ? args.first! as int : 0,
        );

      case AppRoutes.mealDetails:
        return MealDetailsScreen(
          // The meal entity travels as a route argument, so the screen renders
          // instantly and keeps working offline.
          meal: args.isNotEmpty
              ? args.first! as MealEntity
              : const _MissingMeal(),
        );

      case AppRoutes.cart:
        return const CartScreen();

      case AppRoutes.orderConfirmation:
        return const OrderConfirmationScreen();

      case AppRoutes.vendorMap:
        return const VendorMapScreen();

      case AppRoutes.profile:
        return const ProfileScreen();

      default:
        // Unknown route (bad deep link): land on the splash rather than crash.
        return const SplashScreen();
    }
  }
}

/// Rendered only if `mealDetails` is requested with no argument — a defensive
/// default so a malformed deep link shows an empty shell instead of throwing.
class _MissingMeal extends MealEntity {
  const _MissingMeal()
    : super(
        id: '',
        name: '',
        category: '',
        area: '',
        instructions: '',
        thumbnailUrl: '',
        price: 0,
      );
}
