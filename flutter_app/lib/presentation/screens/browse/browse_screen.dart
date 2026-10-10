import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../extensions/l10n_extension.dart';
import '../../widgets/app_network_image.dart';
import '../../blocs/meals/meals_cubit.dart';
import '../../blocs/meals/meals_state.dart';
import '../../widgets/section_header.dart';

/// "Browse" tab: the category grid plus the entry point to the Vendor Map.
///
/// The categories map onto real TheMealDB categories so tapping one filters the
/// grid instead of being a dead decoration.
class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  static const List<({IconData icon, String labelKey, String apiCategory})>
  _categories = [
    (
      icon: Icons.local_fire_department_rounded,
      labelKey: 'categoriesChicken',
      apiCategory: 'Chicken',
    ),
    (
      icon: Icons.local_pizza_rounded,
      labelKey: 'categoriesPizza',
      apiCategory: 'Pizza',
    ),
    (
      icon: Icons.ramen_dining_rounded,
      labelKey: 'categoriesRamen',
      apiCategory: 'Pasta',
    ),
    (
      icon: Icons.lunch_dining_rounded,
      labelKey: 'categoriesBurgers',
      apiCategory: 'Beef',
    ),
    (
      icon: Icons.icecream_rounded,
      labelKey: 'categoriesDesserts',
      apiCategory: 'Dessert',
    ),
    (
      icon: Icons.set_meal_rounded,
      labelKey: 'categoriesSeafood',
      apiCategory: 'Seafood',
    ),
    (
      icon: Icons.eco_rounded,
      labelKey: 'categoriesVegetarian',
      apiCategory: 'Vegan',
    ),
    (
      icon: Icons.breakfast_dining_rounded,
      labelKey: 'categoriesAll',
      apiCategory: '',
    ),
  ];

  String? _selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.browseTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.horizontalPadding(context),
            vertical: 8,
          ),
          child: Responsive.constrainWidth(
            context,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _MapCallToAction(
                  onTap: () =>
                      Navigator.of(context).pushNamed(AppRoutes.vendorMap),
                ),
                const SizedBox(height: 8),
                GridView.builder(
                  key: const ValueKey('browse_categories_grid'),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: Responsive.mealGridColumns(context),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.25,
                  ),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isSelected = _selected == category.apiCategory;
                    return InkWell(
                      key: ValueKey('browse_category_${category.apiCategory}'),
                      onTap: () => setState(
                        () => _selected = isSelected
                            ? null
                            : category.apiCategory,
                      ),
                      borderRadius: BorderRadius.circular(18),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.primarySoft,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              category.icon,
                              size: 30,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.primaryDark,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              context.trKey(category.labelKey),
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.primaryDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                SectionHeader(
                  title: context.l10n.hotOffers,
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 12),
                ),
                const _CategoryPeek(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Full-width card that opens the Google Map — the tab's headline action.
class _MapCallToAction extends StatelessWidget {
  const _MapCallToAction({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      key: const ValueKey('browse_open_map_card'),
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [AppColors.splashTop, AppColors.splashBottom],
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.map_rounded, color: Colors.white, size: 34),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.vendorMap,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    context.l10n.nearYou,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

/// Small preview of the first few cached meals for the selected category.
class _CategoryPeek extends StatelessWidget {
  const _CategoryPeek();

  @override
  Widget build(BuildContext context) {
    final meals = _peekMeals(context);

    if (meals.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: meals.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final meal = meals[index];
          return GestureDetector(
            key: ValueKey('browse_meal_${meal.id}'),
            onTap: () =>
                Navigator.of(context)
                    .pushNamed(AppRoutes.mealDetails, arguments: [meal]),
            child: SizedBox(
              width: 130,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppNetworkImage(
                    url: meal.thumbnailUrl,
                    width: 130,
                    height: 96,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    meal.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Reads the already-loaded feed from the shared cubit — the Browse tab never
  /// issues its own request, which is what keeps navigation instant.
  List<dynamic> _peekMeals(BuildContext context) {
    final state = context.read<MealsCubit>().state;
    if (state is! MealsLoaded) return const [];
    return state.meals.take(8).toList();
  }
}
