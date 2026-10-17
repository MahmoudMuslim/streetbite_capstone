import '../../core/constants/app_constants.dart';
import '../../core/network/dio_client.dart';
import '../models/meal_model.dart';

/// Remote data source for the TheMealDB menu feed.
///
/// A data source has exactly one responsibility: talk to one external system
/// and hand back models. It knows nothing about caching, formatting or the UI,
/// and it never swallows an error — each failure leaves as a typed exception
/// that `MealRepositoryImpl` converts into a `Failure`.
class MealRemoteDataSource {
  const MealRemoteDataSource(this._client);

  final DioClient _client;

  /// Fetches every meal. TheMealDB returns `{meals: [...]}`.
  Future<List<MealModel>> getMeals() async {
    final json = await _client.getJson(AppConstants.mealsEndpoint);
    return _extractMeals(json);
  }

  /// Fetches the "Hot Offers" strip (filtered by category server-side).
  Future<List<MealModel>> getHotOffers({int limit = 5}) async {
    final json = await _client.getJson(AppConstants.hotOffersEndpoint);
    final meals = _extractMeals(json);
    return meals.take(limit).toList();
  }

  /// Turns the API envelope into models, defensively.
  ///
  /// `{"meals": null}` is a *valid* TheMealDB answer meaning "no match", and
  /// it must not be treated as a crash — that is why this returns an empty
  /// list instead of throwing.
  List<MealModel> _extractMeals(Map<String, dynamic> json) {
    final raw = json['meals'];
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((meal) => MealModel.fromApiJson(Map<String, dynamic>.from(meal)))
        .where((meal) => meal.id.isNotEmpty)
        .toList();
  }
}
