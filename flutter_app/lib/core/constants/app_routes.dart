/// Named routes for every navigable screen in StreetBite.
///
/// Centralising route names (and their typed arguments) keeps navigation free
/// of duplicated string literals — see `AppRoutes.goTo(...)` helpers.
class AppRoutes {
  const AppRoutes._();

  static const String splash = '/';
  static const String login = '/login';
  static const String signUp = '/signUp';
  static const String home = '/home';
  static const String mealDetails = '/meal-details';
  static const String cart = '/cart';
  static const String orderConfirmation = '/order-confirmation';
  static const String vendorMap = '/vendor-map';
  static const String profile = '/profile';

  /// Bottom-navigation tab indices (Home · Browse · Orders · Profile).
  static const int tabHome = 0;
  static const int tabBrowse = 1;
  static const int tabOrders = 2;
  static const int tabProfile = 3;
}
