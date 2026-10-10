import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/string_helpers.dart';
import '../../domain/entities/meal_entity.dart';
import '../extensions/l10n_extension.dart';
import 'app_network_image.dart';

/// A single tile in the Home screen meals `GridView` (2 columns on a phone).
///
/// Implements the Figma "Restaurant card": image, name, category, and the
/// add-to-cart affordance. The add button carries a stable `Key` so the Appium
/// suite can address it without depending on the visual order of the grid.
class MealCard extends StatelessWidget {
  const MealCard({
    super.key,
    required this.meal,
    required this.onTap,
    required this.onAddToCart,
    this.isFavourite = false,
    this.onToggleFavourite,
  });

  final MealEntity meal;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;

  final bool isFavourite;
  final VoidCallback? onToggleFavourite;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'meal-image-${meal.id}',
                    child: AppNetworkImage(
                      key: ValueKey('meal_image_${meal.id}'),
                      url: meal.thumbnailUrl,
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  if (onToggleFavourite != null)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: _FavouriteButton(
                        isFavourite: isFavourite,
                        onPressed: onToggleFavourite!,
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          meal.name,
                          key: ValueKey('meal_name_${meal.id}'),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontSize: 14,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          meal.category,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          formatPrice(meal.price),
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _AddToCartButton(onPressed: onAddToCart),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The round "+" button on every card; one instance per meal.
class _AddToCartButton extends StatelessWidget {
  const _AddToCartButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      button: true,
      label: context.l10n.addToCart,
      child: InkWell(
        // Stable accessibility id consumed by the Appium `AddToCartTest`.
        key: const ValueKey('add_to_cart_button'),
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.add_rounded,
            color: theme.colorScheme.primary,
            size: 22,
          ),
        ),
      ),
    );
  }
}

class _FavouriteButton extends StatelessWidget {
  const _FavouriteButton({required this.isFavourite, required this.onPressed});

  final bool isFavourite;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.35),
      shape: const CircleBorder(),
      child: InkWell(
        key: const ValueKey('favourite_button'),
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(
            isFavourite
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            size: 18,
            color: isFavourite ? AppColors.hotOffer : Colors.white,
          ),
        ),
      ),
    );
  }
}
