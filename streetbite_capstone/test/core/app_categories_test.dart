import 'package:flutter_test/flutter_test.dart';
import 'package:streetbite_capstone/core/constants/app_categories.dart';

import '../helpers/test_fixtures.dart';

void main() {
  group('AppCategory.matches', () {
    test('matches the TheMealDB category case-insensitively', () {
      final chicken = AppCategory.byApiCategory('Chicken');

      expect(chicken!.matches(TestFixtures.meal(category: 'chicken')), isTrue);
      expect(chicken.matches(TestFixtures.meal(category: 'CHICKEN')), isTrue);
      expect(chicken.matches(TestFixtures.meal(category: 'Beef')), isFalse);
    });

    test('Vegetarian also catches TheMealDB Vegan meals', () {
      final vegetarian = AppCategory.byApiCategory('Vegetarian');

      expect(
        vegetarian!.matches(TestFixtures.meal(category: 'Vegan')),
        isTrue,
        reason: 'A Vegan meal must not disappear when Vegetarian is selected',
      );
      expect(
        vegetarian.matches(TestFixtures.meal(category: 'Dessert')),
        isFalse,
      );
    });

    test('every chip label key exists so no category renders blank', () {
      expect(AppCategory.all, isNotEmpty);
      for (final category in AppCategory.all) {
        expect(category.labelKey, isNotEmpty);
        expect(category.apiCategory, isNotEmpty);
      }
    });

    test('apiCategory is unique across the table', () {
      final keys = AppCategory.all.map((category) => category.apiCategory);

      expect(keys.toSet().length, AppCategory.all.length);
    });

    test('byApiCategory returns null for unknown and null input', () {
      expect(AppCategory.byApiCategory(null), isNull);
      expect(AppCategory.byApiCategory('Starters'), isNull);
    });
  });
}
