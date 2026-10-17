/// Global, immutable configuration constants for StreetBite.
///
/// Everything that could otherwise be a "magic value" scattered through the
/// code base lives here so that the app has a single source of truth.
class AppConstants {
  const AppConstants._();

  /// Human readable application name (also used as the Android/iOS label).
  static const String appName = 'StreetBite';

  /// Base endpoint of the free [TheMealDB](https://www.themealdb.com/api.php)
  /// REST API used to populate the live menu feed.
  static const String baseUrl = 'https://www.themealdb.com/api/';

  /// Endpoint that returns every meal (first page is enough for a feed).
  static const String mealsEndpoint = 'json/v1/1/search.php?s=';

  /// Endpoint that returns a single meal by its TheMealDB id.
  static const String mealByIdEndpoint = 'json/v1/1/lookup.php?i=';

  /// Endpoint used for the horizontally scrolling "Hot Offers" strip.
  static const String hotOffersEndpoint = 'json/v1/1/filter.php?c=Beef';

  /// Keys used with [SharedPreferences] to cache the remote payload so the
  /// feed renders instantly (and offline) on the next launch.
  static const String cacheMealsKey = 'streetbite_cache_meals';
  static const String cacheHotOffersKey = 'streetbite_cache_hot_offers';
  static const String cacheTimestampKey = 'streetbite_cache_timestamp';

  /// How long a cached payload is considered fresh (24 hours).
  static const Duration cacheTtl = Duration(hours: 24);

  /// Firestore collection names. Centralised so the schema is auditable.
  static const String usersCollection = 'users';
  static const String ordersCollection = 'orders';
  static const String favouritesCollection = 'favourites';

  /// Firestore sub-collection holding a user's favourites.
  static const String userFavouritesSubCollection = 'favourites';

  /// Timeout applied to every Dio call so the UI never hangs forever.
  static const Duration networkTimeout = Duration(seconds: 20);

  /// How long an order counts as still being prepared and delivered.
  ///
  /// Once it elapses since `OrderEntity.placedAt` the order leaves the
  /// "Current" block on the Orders screen and belongs to "Past".
  static const Duration orderActiveWindow = Duration(minutes: 45);

  /// When `true` the app transparently falls back to an on-device data source
  /// if Firebase cannot be reached (offline demo / CI / device without a
  /// configured Firebase project). Set to `false` in production builds to make
  /// Firebase failures surface to the user.
  static const bool allowOfflineFirebaseFallback = true;

  /// Seed credentials created on first launch when running with the offline
  /// fallback so the app (and the Appium suite) always has a valid account.
  static const String demoUserEmail = 'yasmine@streetbite.app';
  static const String demoUserPassword = 'StreetBite123';
  static const String demoUserName = 'Yasmine Adel';

  /// Number of vendors pinned on the Vendor Map screen.
  static const int vendorCount = 5;

  /// Default simulated price applied to meals coming from TheMealDB, which does
  /// not expose prices. The value is deterministic (derived from the meal id)
  /// so cached meals keep a stable price between launches.
  static const double baseMealPrice = 8.99;
}
