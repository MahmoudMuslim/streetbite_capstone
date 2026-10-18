import '../../core/error/either.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/meal_entity.dart';
import '../../domain/repositories/meal_repository.dart';
import '../datasources/meal_local_data_source.dart';
import '../datasources/meal_remote_data_source.dart';
import '../models/meal_model.dart';

/// Which data source should serve a request.
enum MealDataSource {
  /// Live payload from TheMealDB via Dio, never the cache.
  remote,

  /// Payload previously written to `shared_preferences`, never the network.
  local,

  /// Remote first, local as a transparent fallback — the app default.
  remoteThenLocal,
}

/// **Factory pattern applied to data access** — this is the concrete form of
/// the requirement *"use the Factory Pattern in the MealRepository to select
/// between remote API and local cache data sources"*.
///
/// Rather than a `switch` scattered over the call sites, the *decision* lives
/// in one method, [selectDataSource]. A caller (the pull-to-refresh gesture, a
/// future "offline mode" toggle) asks for a strategy and the repository wires
/// the matching pair of data sources. Adding a third backend (say GraphQL)
/// means one enum value and one branch here — no other file changes.
///
/// The repository is registered with the **Factory Method** flavour of the
/// pattern in `injection.dart`: the `MealRepository` interface is bound to
/// *this* concrete class, so no other layer ever sees `MealRepositoryImpl`.
class MealRepositoryImpl implements MealRepository {
  const MealRepositoryImpl({required this._remote, required this._local});

  final MealRemoteDataSource _remote;
  final MealLocalDataSource _local;

  /// Strategy used by the Home feed: fresh data, cache as a safety net.
  static const MealDataSource defaultSource = MealDataSource.remoteThenLocal;

  @override
  Future<Either<Failure, List<MealEntity>>> getMeals() =>
      _fetch(source: defaultSource, isHotOffers: false);

  @override
  Future<Either<Failure, List<MealEntity>>> getHotOffers() =>
      _fetch(source: defaultSource, isHotOffers: true);

  // ---------------------------------------------------------------------------
  // The factory
  // ---------------------------------------------------------------------------

  /// Decides *which concrete data sources* satisfy [requested].
  ///
  /// Today the only rule is "never hit the network for a local-only request",
  /// but the method exists so the mapping from intent to data sources has a
  /// single home and can be unit tested in isolation.
  MealDataSource selectDataSource(MealDataSource requested) {
    if (requested == MealDataSource.local) return MealDataSource.local;
    return MealDataSource.remoteThenLocal;
  }

  // ---------------------------------------------------------------------------
  // Fetching
  // ---------------------------------------------------------------------------

  /// Loads a list of meals through the strategy chosen by the factory.
  ///
  /// Every failure path ends in a [Failure] and never in a thrown exception,
  /// so the Cubit only ever deals with the sealed `Either` type.
  Future<Either<Failure, List<MealEntity>>> _fetch({
    required MealDataSource source,
    required bool isHotOffers,
  }) async {
    switch (selectDataSource(source)) {
      case MealDataSource.remote:
        try {
          final meals = await _loadRemote(isHotOffers);
          await _persist(isHotOffers, meals);
          return Right<Failure, List<MealEntity>>(meals);
        } on NetworkException catch (error) {
          return Left(ServerFailure(details: error.message));
        }

      case MealDataSource.local:
        final cached = _readCache(isHotOffers);
        if (cached.isEmpty) {
          return const Left<Failure, List<MealEntity>>(CacheFailure());
        }
        return Right<Failure, List<MealEntity>>(cached);

      case MealDataSource.remoteThenLocal:
        try {
          final meals = await _loadRemote(isHotOffers);
          await _persist(isHotOffers, meals);
          return Right<Failure, List<MealEntity>>(meals);
        } on NetworkException catch (error) {
          // Network down — degrade to the cache instead of an error screen.
          final cached = _readCache(isHotOffers);
          if (cached.isNotEmpty) {
            return Right<Failure, List<MealEntity>>(cached);
          }
          return Left(ServerFailure(details: error.message));
        } on SerializationException catch (error) {
          return Left(CacheFailure(details: error.message));
        }
    }
  }

  Future<List<MealModel>> _loadRemote(bool isHotOffers) =>
      isHotOffers ? _remote.getHotOffers() : _remote.getMeals();

  List<MealModel> _readCache(bool isHotOffers) {
    try {
      return isHotOffers
          ? _local.getHotOffers() ?? []
          : _local.getMeals() ?? [];
    } on SerializationException {
      // A corrupt cache must not crash the feed; treat it as "no cache".
      return [];
    }
  }

  /// Writes a successful response into the matching cache slot.
  Future<void> _persist(bool isHotOffers, List<MealModel> meals) async {
    if (meals.isEmpty) return;
    if (isHotOffers) {
      await _local.cacheHotOffers(meals);
    } else {
      await _local.cacheMeals(meals);
    }
  }
}
