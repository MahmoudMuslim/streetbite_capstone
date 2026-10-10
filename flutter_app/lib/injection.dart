import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  // ---- Firestore singleton -------------------------------------------------
  // `FirestoreService()` always returns the same object, so this registration
  // merely hands that object to the container.
  sl.registerLazySingleton<FirestoreService>(FirestoreService.new);

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
    debugPrint('StreetBite: Firebase initialised.');
  } catch (error) {
    sl<FirestoreService>().configure(null);
    debugPrint(
      'StreetBite: Firebase unavailable ($error) — '
      'falling back to on-device data sources.',
    );
  }
}
