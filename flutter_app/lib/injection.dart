import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/constants/app_constants.dart';
import 'core/network/dio_client.dart';
import 'data/datasources/auth_local_data_source.dart';
import 'data/datasources/auth_remote_data_source.dart';
import 'data/datasources/firestore_service.dart';
import 'data/datasources/meal_local_data_source.dart';
import 'data/datasources/meal_remote_data_source.dart';
import 'data/datasources/vendor_local_data_source.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/favourite_repository_impl.dart';
import 'data/repositories/meal_repository_impl.dart';
import 'data/repositories/order_repository_impl.dart';
import 'data/repositories/profile_repository_impl.dart';
import 'data/repositories/vendor_repository_impl.dart';
import 'data/services/biometric_service.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/favourite_repository.dart';
import 'domain/repositories/meal_repository.dart';
import 'domain/repositories/order_repository.dart';
import 'domain/repositories/profile_repository.dart';
import 'domain/repositories/vendor_repository.dart';
import 'domain/usecases/add_to_cart.dart';
import 'domain/usecases/calculate_order_totals.dart';
import 'domain/usecases/get_device_info.dart';
import 'domain/usecases/get_favourites.dart';
import 'domain/usecases/get_meals.dart';
import 'domain/usecases/get_nearby_vendors.dart';
import 'domain/usecases/get_order_history.dart';
import 'domain/usecases/get_user_profile.dart';
import 'domain/usecases/login_user.dart';
import 'domain/usecases/logout_user.dart';
import 'domain/usecases/pick_and_upload_photo.dart';
import 'domain/usecases/place_order.dart';
import 'domain/usecases/remove_from_cart.dart';
import 'domain/usecases/restore_session.dart';
import 'domain/usecases/save_user_profile.dart';
import 'domain/usecases/signup_user.dart';
import 'domain/usecases/toggle_favourite.dart';
import 'presentation/blocs/auth/auth_cubit.dart';
import 'presentation/blocs/cart/cart_bloc.dart';
import 'presentation/blocs/favourites/favourites_cubit.dart';
import 'presentation/blocs/locale/locale_cubit.dart';
import 'presentation/blocs/meals/meals_cubit.dart';
import 'presentation/blocs/orders/orders_cubit.dart';
import 'presentation/blocs/theme/theme_cubit.dart';

/// The service locator.
///
/// Registration rules used throughout StreetBite
/// ---------------------------------------------
/// * **External SDKs** (`DioClient`, `SharedPreferences`, plugins) — registered
///   once as singletons because they own a connection pool / platform channel.
/// * **Data sources** — singletons for the same reason (a cache is only correct
///   if there is exactly one of it).
/// * **Repositories** — bound to their **abstract interface** using the
///   *Factory Method* flavour of the Factory pattern. Screens only ever ask
///   GetIt for `MealRepository`, never for `MealRepositoryImpl`, so swapping the
///   implementation is a one-line change here.
/// * **Use cases** — `factory` registrations: they are cheap value objects and
///   are rebuilt for every consumer, which keeps them free of shared state.
/// * **Cubits / Blocs** — `lazySingleton`, because the cart badge and the cart
///   screen must observe the *same* `CartBloc` instance app-wide.
final GetIt sl = GetIt.instance;

/// Wires the whole object graph. Call once from `main()` before `runApp`.
Future<void> configureDependencies() async {
  // ---- Firestore singleton ------------------------------------------------
  // Registered **first** because `_initFirebaseSafely()` resolves it in order
  // to hand it the Firebase instance. Resolving a type before it is registered
  // throws out of GetIt and would abort the rest of this method, leaving the
  // cubits unregistered and crashing `main()`.
  //
  // `FirestoreService()` always returns the same object, so this registration
  // merely hands that object to the container.
  sl.registerLazySingleton<FirestoreService>(FirestoreService.new);

  // ---- Firebase ------------------------------------------------------------
  // Failure is tolerated on purpose: the app degrades to its on-device data
  // sources (see `AuthRepositoryImpl`), so a missing `google-services.json`
  // produces a working demo instead of a black screen.
  await _initFirebaseSafely();

  // ---- External singletons -------------------------------------------------
  sl.registerLazySingleton<DioClient>(DioClient.new);

  // `SharedPreferences.getInstance()` is asynchronous, and the cache has to be
  // warm *before* any screen reads it, so this one is resolved eagerly here
  // rather than lazily.
  final preferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(preferences);

  sl.registerLazySingleton<DeviceInfoPlugin>(DeviceInfoPlugin.new);
  sl.registerLazySingleton<ImagePicker>(ImagePicker.new);
  sl.registerLazySingleton<BiometricService>(BiometricService.new);

  // Registered so the bootstrap below (and any future code) can talk to
  // Firebase Auth through the container instead of the global singleton.
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  // ---- Data sources --------------------------------------------------------
  sl.registerLazySingleton<MealRemoteDataSource>(
    () => MealRemoteDataSource(sl<DioClient>()),
  );
  sl.registerLazySingleton<MealLocalDataSource>(
    () => MealLocalDataSource(sl<SharedPreferences>()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSource(sl<SharedPreferences>()),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(FirebaseAuth.instance),
  );
  sl.registerLazySingleton<VendorLocalDataSource>(VendorLocalDataSource.new);

  // ---- Repositories (bound to their interface) -----------------------------
  sl.registerLazySingleton<MealRepository>(
    () => MealRepositoryImpl(
      remote: sl<MealRemoteDataSource>(),
      local: sl<MealLocalDataSource>(),
    ),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remote: sl<AuthRemoteDataSource>(),
      local: sl<AuthLocalDataSource>(),
    ),
  );
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl<FirestoreService>()),
  );
  sl.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(sl<FirestoreService>()),
  );
  sl.registerLazySingleton<FavouriteRepository>(
    () => FavouriteRepositoryImpl(sl<FirestoreService>()),
  );
  sl.registerLazySingleton<VendorRepository>(
    () => VendorRepositoryImpl(sl<VendorLocalDataSource>()),
  );

  // ---- Use cases (factories: stateless and cheap) --------------------------
  sl.registerFactory<RestoreSession>(
    () => RestoreSession(sl<AuthRepository>()),
  );
  sl.registerFactory<LoginUser>(() => LoginUser(sl<AuthRepository>()));
  sl.registerFactory<SignUpUser>(() => SignUpUser(sl<AuthRepository>()));
  sl.registerFactory<LogoutUser>(() => LogoutUser(sl<AuthRepository>()));

  sl.registerFactory<GetMeals>(() => GetMeals(sl<MealRepository>()));
  sl.registerFactory<GetHotOffers>(() => GetHotOffers(sl<MealRepository>()));
  sl.registerFactory<ClearMealCache>(
    () => ClearMealCache(sl<MealRepository>()),
  );

  sl.registerFactory<AddToCart>(AddToCart.new);
  sl.registerFactory<RemoveFromCart>(RemoveFromCart.new);
  sl.registerFactory<CalculateOrderTotals>(CalculateOrderTotals.new);
  sl.registerFactory<PlaceOrder>(() => PlaceOrder(sl<OrderRepository>()));
  sl.registerFactory<GetOrderHistory>(
    () => GetOrderHistory(sl<OrderRepository>()),
  );

  sl.registerFactory<ToggleFavourite>(
    () => ToggleFavourite(sl<FavouriteRepository>()),
  );
  sl.registerFactory<GetFavourites>(
    () => GetFavourites(sl<FavouriteRepository>()),
  );

  sl.registerFactory<SaveUserProfile>(
    () => SaveUserProfile(sl<ProfileRepository>()),
  );
  sl.registerFactory<GetUserProfile>(
    () => GetUserProfile(sl<ProfileRepository>()),
  );
  sl.registerFactory<PickAndUploadPhoto>(
    () => PickAndUploadPhoto(sl<ImagePicker>(), sl<ProfileRepository>()),
  );

  sl.registerFactory<GetNearbyVendors>(
    () => GetNearbyVendors(sl<VendorRepository>()),
  );
  sl.registerFactory<GetDeviceInfo>(
    () => GetDeviceInfo(sl<DeviceInfoPlugin>()),
  );

  // ---- Presentation (long-lived, shared app-wide) --------------------------
  sl.registerLazySingleton<ThemeCubit>(
    () => ThemeCubit(sl<SharedPreferences>()),
  );
  sl.registerLazySingleton<LocaleCubit>(
    () => LocaleCubit(sl<SharedPreferences>()),
  );

  sl.registerLazySingleton<AuthCubit>(
    () => AuthCubit(
      restoreSession: sl<RestoreSession>(),
      loginUser: sl<LoginUser>(),
      signUpUser: sl<SignUpUser>(),
      logoutUser: sl<LogoutUser>(),
    ),
  );
  sl.registerLazySingleton<MealsCubit>(
    () =>
        MealsCubit(getMeals: sl<GetMeals>(), getHotOffers: sl<GetHotOffers>()),
  );
  sl.registerLazySingleton<CartBloc>(
    () => CartBloc(
      addToCart: sl<AddToCart>(),
      removeFromCart: sl<RemoveFromCart>(),
      calculateTotals: sl<CalculateOrderTotals>(),
      placeOrder: sl<PlaceOrder>(),
    ),
  );
  sl.registerLazySingleton<FavouritesCubit>(
    () => FavouritesCubit(
      getFavourites: sl<GetFavourites>(),
      toggleFavourite: sl<ToggleFavourite>(),
    ),
  );
  sl.registerLazySingleton<OrdersCubit>(
    () => OrdersCubit(sl<GetOrderHistory>()),
  );

  // ---- Bootstrap ---------------------------------------------------------
  // The demo account is a *composition-root* concern: it seeds the on-device
  // store that the local auth fallback reads. Doing it here means `main.dart`
  // never has to resolve a concrete data-layer class, which would defeat the
  // interface-only registration above.
  await _seedQaAccount();
}

/// Creates the QA account the Appium suite signs in with.
///
/// The account has to exist in **both** stores:
///
/// * the on-device store, which `AuthLocalDataSource` reads when Firebase is
///   unreachable, and
/// * Firebase Auth, because that is what `login()` talks to first.
///
/// Seeding only the local store is a subtle trap: with Firebase reachable the
/// sign-in would be rejected with "Incorrect email or password", which looks
/// like an auth bug but is really a missing seed. Registering here makes the
/// account real, so the manual suite, the Appium suite and a human tester all
/// exercise the same genuine code path.
///
/// Idempotent and deliberately non-fatal: "already exists" is the expected
/// outcome on every launch after the first.
Future<void> _seedQaAccount() async {
  try {
    await sl<AuthLocalDataSource>().ensureDemoAccount();
  } catch (error) {
    debugPrint('StreetBite: could not seed the local QA account ($error)');
  }

  if (!sl<FirestoreService>().isAvailable) return;

  final auth = sl<FirebaseAuth>();

  // Whether *this* call authenticated anyone.
  //
  // `createUserWithEmailAndPassword` signs the new user in as a side effect, so
  // a sign-out is needed after that - and only after that. Signing out
  // unconditionally was far worse than the problem it solved: because seeding
  // runs on *every* launch, the app signed the real user out of their own
  // session each time they opened it. The session was restored by the splash
  // and then immediately destroyed, so the next cold start had nothing to
  // restore and dropped the user on the Login screen.
  var authenticatedHere = false;

  try {
    final credential = await auth.createUserWithEmailAndPassword(
      email: AppConstants.demoUserEmail,
      password: AppConstants.demoUserPassword,
    );
    authenticatedHere = true;
    // A Firebase account carries no display name unless one is written, and
    // the Home AppBar greets the user by name - so set it explicitly.
    await credential.user?.updateDisplayName(AppConstants.demoUserName);
    debugPrint('StreetBite: QA account created in Firebase Auth.');
  } on FirebaseAuthException catch (error) {
    if (error.code != 'email-already-in-use') {
      debugPrint(
        'StreetBite: could not seed the Firebase QA account (${error.code})',
      );
      return;
    }

    // Already created by an earlier launch. Nothing more to do: the display
    // name was written to the account when it was first created and persists
    // server-side.
    //
    // Deliberately *not* signing in here. Every cold start seeds, so an extra
    // sign-in per launch is a needless network round trip that also risks
    // tripping Firebase's auth throttling - which showed up in automation as a
    // splash that never finished.
    debugPrint('StreetBite: QA account already present in Firebase Auth.');
  } catch (error) {
    debugPrint('StreetBite: could not seed the Firebase QA account ($error)');
  } finally {
    // Only undo a sign-in that *we* performed. Signing out when the account
    // already existed (and the real user was signed in) logged them out.
    if (authenticatedHere) {
      try {
        await auth.signOut();
      } catch (_) {
        // Nothing useful to do; the account exists either way.
      }
    }
  }
}

/// Initialises Firebase and hands the Firestore instance to the singleton.
///
/// Everything is wrapped: a missing `google-services.json`, a device without
/// Play Services, or a network error during start-up must never prevent the
/// app from launching — the repositories have local fallbacks precisely for
/// that case.
Future<void> _initFirebaseSafely() async {
  try {
    await Firebase.initializeApp();
    sl<FirestoreService>().configure(FirebaseFirestore.instance);
    await _waitForAuthSessionRestore();
    debugPrint('StreetBite: Firebase initialised.');
  } catch (error) {
    // `configure(null)` puts the singleton into local mode. It is wrapped in
    // its own try/catch so that a failure here can never abort the rest of
    // `configureDependencies()` - a half-wired container is far worse than a
    // missing Firestore.
    try {
      sl<FirestoreService>().configure(null);
    } catch (_) {
      // The singleton is simply left unconfigured; `isAvailable` stays false
      // and the repositories fall back to their local data sources.
    }
    debugPrint(
      'StreetBite: Firebase unavailable ($error) — '
      'falling back to on-device data sources.',
    );
  }
}

/// Blocks until Firebase Auth has finished restoring its persisted session.
///
/// This is a race, and it is a nasty one because the failure is invisible.
///
/// `Firebase.initializeApp()` returning does **not** mean Auth is ready. The
/// SDK reloads any saved session from disk *asynchronously*, so
/// `currentUser` is still `null` for a short window afterwards. Reading it too
/// early made the app believe nobody was signed in, fall back to its local
/// session store, and therefore start Firestore requests with **no** auth
/// token. The server answered `PERMISSION_DENIED: Missing or insufficient
/// permissions` — indistinguishable from wrong security rules, which is why
/// this cost a long detour into the rules before the real cause surfaced.
///
/// The symptom that gives it away: a *fresh sign-in* worked perfectly, because
/// logging in populates Auth synchronously, while every *cold restart* failed
/// to load favourites and orders.
///
/// `userChanges()` emits once Auth has finished loading, with either the
/// restored user or `null` when genuinely signed out. The timeout is a
/// belt-and-braces guard: on a device with no Play Services this stream may
/// never emit, and a stuck splash is worse than a slow one.
Future<void> _waitForAuthSessionRestore() async {
  try {
    await FirebaseAuth.instance.userChanges().first.timeout(
      const Duration(seconds: 10),
    );
  } catch (_) {
    debugPrint(
      'StreetBite: Auth session restore timed out; continuing with the local '
      'session fallback.',
    );
  }
}
