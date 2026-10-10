import '../../domain/entities/meal_entity.dart';

/// Data-layer representation of a TheMealDB meal.
///
/// Clean Architecture rule: the **model** owns serialisation, the **entity**
/// owns behaviour. Both live in different packages, so swapping the API (or
/// adding a second one) can never leak `Map<String, dynamic>` into a widget.
///
/// Parsing is defensive on purpose — TheMealDB returns `null` for missing
/// fields and uses comma-separated strings for tags — and every accessor has a
/// sensible default so one malformed row can never break the whole feed.
class MealModel extends MealEntity {
  const MealModel({
    required super.id,
    required super.name,
    required super.category,
    required super.area,
    required super.instructions,
    required super.thumbnailUrl,
    required super.price,
    super.tags,
    super.youtubeUrl,
  });

  /// Firestore / TheMealDB identifier for a meal.
  static const String idKey = 'id';
  static const String nameKey = 'name';
  static const String categoryKey = 'category';
  static const String areaKey = 'area';
  static const String instructionsKey = 'instructions';
  static const String thumbnailKey = 'thumbnailUrl';
  static const String priceKey = 'price';
  static const String tagsKey = 'tags';
  static const String youtubeKey = 'youtubeUrl';

  /// TheMealDB uses short keys for some fields when listing meals.
  static const String _apiIdKey = 'idMeal';
  static const String _apiStrMealKey = 'strMeal';
  static const String _apiCategoryKey = 'strCategory';
  static const String _apiAreaKey = 'strArea';
  static const String _apiInstructionsKey = 'strInstructions';
  static const String _apiThumbnailKey = 'strMealThumb';
  static const String _apiTagsKey = 'strTags';
  static const String _apiYoutubeKey = 'strYoutube';

  /// Builds a model from a raw **TheMealDB** payload.
  factory MealModel.fromApiJson(Map<String, dynamic> json) {
    final id = (json[_apiIdKey] ?? '').toString();
    return MealModel(
      id: id,
      name: _clean(json[_apiStrMealKey]),
      category: _clean(json[_apiCategoryKey], fallback: 'Street food'),
      area: _clean(json[_apiAreaKey], fallback: 'International'),
      instructions: _clean(json[_apiInstructionsKey]),
      thumbnailUrl: _clean(json[_apiThumbnailKey]),
      // TheMealDB has no prices, so a stable pseudo-price is derived from the
      // id: the same meal always costs the same across app launches.
      price: priceForId(id),
      tags: _parseTags(json[_apiTagsKey]),
      youtubeUrl: _nullableString(json[_apiYoutubeKey]),
    );
  }

  /// Builds a model from a stored **Firestore** document.
  factory MealModel.fromJson(Map<String, dynamic> json) {
    final id = (json[idKey] ?? '').toString();
    return MealModel(
      id: id,
      name: _clean(json[nameKey], fallback: 'Street Bite'),
      category: _clean(json[categoryKey], fallback: 'Street food'),
      area: _clean(json[areaKey], fallback: 'International'),
      instructions: _clean(json[instructionsKey]),
      thumbnailUrl: _clean(json[thumbnailKey]),
      price: _toDouble(json[priceKey]),
      tags: _parseTags(json[tagsKey]),
      youtubeUrl: _nullableString(json[youtubeKey]),
    );
  }

  /// Serialisable map — the exact shape written to Firestore favourites.
  factory MealModel.fromEntity(MealEntity entity) => MealModel(
    id: entity.id,
    name: entity.name,
    category: entity.category,
    area: entity.area,
    instructions: entity.instructions,
    thumbnailUrl: entity.thumbnailUrl,
    price: entity.price,
    tags: entity.tags,
    youtubeUrl: entity.youtubeUrl,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    idKey: id,
    nameKey: name,
    categoryKey: category,
    areaKey: area,
    instructionsKey: instructions,
    thumbnailKey: thumbnailUrl,
    priceKey: price,
    tagsKey: tags,
    youtubeKey: youtubeUrl,
  };

  /// Deterministic price derived from the TheMealDB id, in the $6.99–$24.99
  /// band used by the Figma design. Keeping it deterministic means the cached
  /// menu and a freshly fetched one always agree.
  static double priceForId(String id) {
    if (id.isEmpty) return 8.99;
    final seed = id.codeUnits.fold<int>(0, (sum, unit) => sum + unit);
    const lowestCents = 699;
    const step = 1800; // 18.00 in cents -> $6.99 .. $24.99
    return (lowestCents + (seed % step)) / 100;
  }

  /// Trims a nullable API value and substitutes [fallback] when it is missing.
  static String _clean(Object? value, {String fallback = ''}) {
    if (value == null) return fallback;
    final text = value.toString().trim();
    if (text.isEmpty || text == 'null' || text == 'Unknown') return fallback;
    return text;
  }

  /// Returns `null` instead of an empty string for genuinely absent values.
  static String? _nullableString(Object? value) {
    final text = _clean(value);
    return text.isEmpty ? null : text;
  }

  static double _toDouble(Object? value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 8.99;
  }

  /// TheMealDB returns tags as `"Beef,Casserole,..."` or a `List`.
  static List<String> _parseTags(Object? value) {
    if (value == null) return const [];
    if (value is List) {
      return value
          .map((tag) => tag.toString())
          .where((tag) => tag.isNotEmpty)
          .toList();
    }
    return value
        .toString()
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList();
  }
}
