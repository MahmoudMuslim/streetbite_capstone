import 'package:flutter/material.dart';

import '../../domain/entities/meal_entity.dart';

/// The seven menu categories shown as chips on the Home screen and as a grid
/// on the Browse tab.
///
/// One table for both screens: the chips and the grid used to carry their own
/// copies of this list, which is how the Home chips ended up as dead
/// decorations while Browse (partially) filtered. A new category is now a
/// one-line change and the two screens cannot drift apart.
///
/// [apiCategory] is the TheMealDB category the selection filters on. TheMealDB
/// has no "Pizza" category, so that chip filters on its literal name and
/// simply yields the empty state until the feed contains one — an honest
/// "no meals found" beats silently showing everything.
class AppCategory {
  const AppCategory({
    required this.icon,
    required this.labelKey,
    required this.apiCategory,
    this.alsoMatches = const [],
  });

  final IconData icon;

  /// ARB key of the visible label, resolved through `context.trKey`.
  final String labelKey;

  final String apiCategory;

  /// Extra TheMealDB categories that belong to this chip. "Vegetarian" has to
  /// catch TheMealDB's `Vegan` meals too, otherwise tapping it hides dishes
  /// every user would expect to see.
  final List<String> alsoMatches;

  bool matches(MealEntity meal) {
    final category = meal.category.toLowerCase();
    if (category == apiCategory.toLowerCase()) return true;
    return alsoMatches.any((alias) => category == alias.toLowerCase());
  }

  static const List<AppCategory> all = [
    AppCategory(
      icon: Icons.local_fire_department_rounded,
      labelKey: 'categoriesChicken',
      apiCategory: 'Chicken',
    ),
    AppCategory(
      icon: Icons.eco_rounded,
      labelKey: 'categoriesVegetarian',
      apiCategory: 'Vegetarian',
      alsoMatches: ['Vegan'],
    ),
    AppCategory(
      icon: Icons.local_pizza_rounded,
      labelKey: 'categoriesPizza',
      apiCategory: 'Pizza',
    ),
    AppCategory(
      icon: Icons.ramen_dining_rounded,
      labelKey: 'categoriesRamen',
      apiCategory: 'Pasta',
    ),
    AppCategory(
      icon: Icons.lunch_dining_rounded,
      labelKey: 'categoriesBurgers',
      apiCategory: 'Beef',
    ),
    AppCategory(
      icon: Icons.icecream_rounded,
      labelKey: 'categoriesDesserts',
      apiCategory: 'Dessert',
    ),
    AppCategory(
      icon: Icons.set_meal_rounded,
      labelKey: 'categoriesSeafood',
      apiCategory: 'Seafood',
    ),
  ];

  static AppCategory? byApiCategory(String? apiCategory) {
    if (apiCategory == null) return null;
    for (final category in all) {
      if (category.apiCategory == apiCategory) return category;
    }
    return null;
  }
}
