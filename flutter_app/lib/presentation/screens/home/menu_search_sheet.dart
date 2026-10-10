import 'package:flutter/material.dart';

import '../../../domain/entities/meal_entity.dart';
import '../../extensions/l10n_extension.dart';

/// Opens the full-menu bottom sheet.
///
/// The Home screen shows a curated subset; "See all" opens this sheet so the
/// user can browse everything TheMealDB returned without leaving the feed.
Future<void> showMenuSearchSheet(BuildContext context, List<MealEntity> meals) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => MenuSearchSheet(meals: meals),
  );
}

/// Search field plus a scrollable list of every meal in the feed.
class MenuSearchSheet extends StatefulWidget {
  const MenuSearchSheet({super.key, required this.meals});

  final List<MealEntity> meals;

  @override
  State<MenuSearchSheet> createState() => _MenuSearchSheetState();
}

class _MenuSearchSheetState extends State<MenuSearchSheet> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = _query.isEmpty
        ? widget.meals
        : widget.meals
              .where(
                (meal) =>
                    meal.name.toLowerCase().contains(_query) ||
                    meal.category.toLowerCase().contains(_query),
              )
              .toList();

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: TextField(
                key: const ValueKey('menu_search_field'),
                controller: _controller,
                onChanged: (value) =>
                    setState(() => _query = value.trim().toLowerCase()),
                decoration: InputDecoration(
                  hintText: context.l10n.searchHint,
                  prefixIcon: const Icon(Icons.search_rounded),
                ),
              ),
            ),
            Expanded(
              child: results.isEmpty
                  ? Center(child: Text(context.l10n.mealNotFound))
                  : ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      itemCount: results.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final meal = results[index];
                        return ListTile(
                          key: ValueKey('menu_sheet_item_${meal.id}'),
                          contentPadding: EdgeInsets.zero,
                          title: Text(meal.name),
                          subtitle: Text(meal.category),
                          trailing: Text(
                            '\$${meal.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
