import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../../core/error/exceptions.dart';
import '../models/meal_model.dart';

/// Local data source backed by `shared_preferences`.
///
/// The whole menu is stored as a single JSON string under one key. That is a
/// deliberate trade-off: TheMealDB returns ~50 small records, so one read is
/// cheaper than 50 and the cache stays trivially inspectable during QA.
///
/// This is the "offline" half of the **Factory pattern** used by
/// `MealRepositoryImpl`: the repository asks for `Remote` or `Local` data and
/// this class *is* the local option.
class MealLocalDataSource {
  const MealLocalDataSource(this._preferences);

  final SharedPreferences _preferences;

  /// Persists the meals together with the fetch timestamp used for TTL checks.
  Future<void> cacheMeals(List<MealModel> meals) async {
    await _preferences.setString(
      AppConstants.cacheMealsKey,
      jsonEncode(meals.map((meal) => meal.toJson()).toList()),
    );
    await _preferences.setString(
      AppConstants.cacheTimestampKey,
      DateTime.now().toIso8601String(),
    );
  }

  /// Persists the Hot Offers strip under its own key so a failure to cache the
  /// offers can never invalidate a good menu cache.
  Future<void> cacheHotOffers(List<MealModel> meals) => _preferences.setString(
    AppConstants.cacheHotOffersKey,
    jsonEncode(meals.map((meal) => meal.toJson()).toList()),
  );

  /// Returns the cached menu, or `null` when nothing has been cached yet.
  ///
  /// A corrupt payload throws [SerializationException] rather than silently
  /// returning an empty list, so the repository can show the real error widget.
  List<MealModel>? getMeals() => _read(AppConstants.cacheMealsKey);

  List<MealModel>? getHotOffers() => _read(AppConstants.cacheHotOffersKey);

  /// `true` while the cache is younger than [AppConstants.cacheTtl].
  bool get isFresh {
    final stamp = _preferences.getString(AppConstants.cacheTimestampKey);
    if (stamp == null) return false;
    final writtenAt = DateTime.tryParse(stamp);
    if (writtenAt == null) return false;
    return DateTime.now().difference(writtenAt) < AppConstants.cacheTtl;
  }

  /// Wipes every cached menu payload (used on sign-out).
  Future<void> clear() async {
    await _preferences.remove(AppConstants.cacheMealsKey);
    await _preferences.remove(AppConstants.cacheHotOffersKey);
    await _preferences.remove(AppConstants.cacheTimestampKey);
  }

  List<MealModel>? _read(String key) {
    final raw = _preferences.getString(key);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return null;
      return decoded
          .whereType<Map>()
          .map((item) => MealModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } on FormatException {
      throw const SerializationException('Corrupt meal cache');
    }
  }
}
