import 'package:streetbite_capstone/domain/entities/meal_entity.dart';

/// Canned entities shared by the test suite.
///
/// Centralising the fixtures means a change to an entity's shape breaks one
/// file instead of twenty tests, and it keeps the tests themselves focused on
/// behaviour rather than on object construction.
class TestFixtures {
  const TestFixtures._();

  static MealEntity meal({
    String id = 'meal-1',
    String name = 'Koshari',
    double price = 12.5,
  }) =>
      MealEntity(
        id: id,
        name: name,
        category: 'Egyptian',
        area: 'Egypt',
        instructions: 'Mix lentils, rice and pasta.',
        thumbnailUrl: 'https://example.com/$id.jpg',
        price: price,
      );

  static List<MealEntity> meals(int count) => List.generate(
        count,
        (index) => meal(id: 'meal-$index', name: 'Meal $index'),
      );
}
