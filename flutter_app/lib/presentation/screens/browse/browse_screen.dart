import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_categories.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_glass_tokens.dart';
import '../../../core/utils/responsive.dart';
import '../../../domain/entities/meal_entity.dart';
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
  String? _selected;

  @override
  Widget build(BuildContext context) {
    final selected = AppCategory.byApiCategory(_selected);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.browseTitle)),
      extendBody: true,
      // The shell's bar is the only bottom chrome, so the inset it publishes is
      // turned into scroll padding instead of being eaten by a bottom SafeArea.
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.horizontalPadding(context),
            vertical: 8,
          ).copyWith(bottom: 8 + Responsive.bottomBarClearance(context)),
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
                  itemCount: AppCategory.all.length + 1,
                  itemBuilder: (context, index) {
                    // The trailing tile clears the filter; the rest select one.
                    if (index == AppCategory.all.length) {
                      return _categoryTile(
                        icon: Icons.breakfast_dining_rounded,
                        labelKey: 'categoriesAll',
                        apiCategory: null,
                        isSelected: _selected == null,
                      );
                    }
                    final category = AppCategory.all[index];
                    return _categoryTile(
                      icon: category.icon,
                      labelKey: category.labelKey,
                      apiCategory: category.apiCategory,
                      isSelected: _selected == category.apiCategory,
                    );
                  },
                ),
                const SizedBox(height: 8),
                SectionHeader(
                  // The strip below previews the *selected* category, so the
                  // heading names it; with no selection it is simply the feed.
                  title: selected == null
                      ? context.l10n.recommended
                      : context.trKey(selected.labelKey),
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 12),
                ),
                _CategoryPeek(selected: selected),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _categoryTile({
    required IconData icon,
    required String labelKey,
    required String? apiCategory,
    required bool isSelected,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isGlass = AppGlassTokens.enabledOf(context);
    final idleIcon = isGlass
        ? theme.colorScheme.onSurface
        : AppColors.primaryDark;
    final idleText = isSelected
        ? Colors.white
        : isGlass
        ? theme.colorScheme.onSurface
        : isDark
        ? Colors.white
        : AppColors.textPrimary;
    return InkWell(
      key: ValueKey('browse_category_${apiCategory ?? 'all'}'),
      onTap: () => setState(() => _selected = isSelected ? null : apiCategory),
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : isGlass
              ? AppGlassTokens.wellColor(context)
              : isDark
              ? AppColors.surfaceDark
              : AppColors.background,
          borderRadius: BorderRadius.circular(18),
          border: isGlass && !isSelected
              ? Border.all(color: AppGlassTokens.wellBorder(context))
              : null,
          boxShadow: isGlass
              ? null
              : [
                  BoxShadow(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.4)
                        : Colors.black.withValues(alpha: isDark ? 0 : 0.06),
                    blurRadius: isSelected ? 14 : 10,
                    offset: const Offset(0, 5),
                  ),
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: isSelected ? Colors.white : idleIcon),
            const SizedBox(height: 8),
            Text(
              context.trKey(labelKey),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: idleText,
              ),
            ),
          ],
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
          boxShadow: [
            BoxShadow(
              color: AppColors.splashBottom.withValues(alpha: 0.4),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
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
///
/// The selection is applied *here*, which is the whole point of the grid
/// above: before this, tapping a category recoloured the tile and changed
/// nothing else, so the filter looked broken to every tester.
class _CategoryPeek extends StatelessWidget {
  const _CategoryPeek({required this.selected});

  final AppCategory? selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final meals = _peekMeals(context);

    if (meals.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            context.l10n.mealNotFound,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }

    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: meals.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final meal = meals[index];
          final isGlass = AppGlassTokens.enabledOf(context);
          return GestureDetector(
            key: ValueKey('browse_meal_${meal.id}'),
            onTap: () =>
                Navigator.of(context)
                    .pushNamed(AppRoutes.mealDetails, arguments: [meal]),
            child: Container(
              width: 130,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isGlass
                    ? AppGlassTokens.wellColor(context)
                    : theme.brightness == Brightness.dark
                    ? AppColors.surfaceDark
                    : AppColors.background,
                borderRadius: BorderRadius.circular(16),
                border: isGlass
                    ? Border.all(color: AppGlassTokens.wellBorder(context))
                    : null,
                boxShadow: isGlass
                    ? null
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppNetworkImage(
                    url: meal.thumbnailUrl,
                    width: 114,
                    height: 84,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    meal.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.brightness == Brightness.dark
                          ? Colors.white
                          : AppColors.textPrimary,
                    ),
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
  List<MealEntity> _peekMeals(BuildContext context) {
    final state = context.read<MealsCubit>().state;
    if (state is! MealsLoaded) return const [];
    final meals = state.meals;
    final category = selected;
    if (category == null) return meals.take(8).toList();
    return meals.where(category.matches).take(8).toList();
  }
}
