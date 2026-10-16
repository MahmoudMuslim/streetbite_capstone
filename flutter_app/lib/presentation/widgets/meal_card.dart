import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_glass_tokens.dart';
import '../../../core/utils/string_helpers.dart';
import '../../../domain/entities/meal_entity.dart';
import '../extensions/l10n_extension.dart';
import 'app_network_image.dart';
import 'app_surface.dart';
import 'semantic_id.dart';

/// A single tile in the Home screen meals `GridView` (2 columns on a phone).
///
/// Implements the Figma "Restaurant card": image, name, category, price and the
/// add-to-cart affordance. Every interactive node carries a
/// [SemanticId] so the Appium suite can address it by `resource-id` instead of
/// by position — which is what makes the suite survive a redesign.
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

    return SemanticId(
      id: 'meal_card_${meal.id}',
      label: meal.name,
      // Without this, Flutter folds the card's text *and* its buttons into one
      // accessibility node and the Add-to-Cart `resource-id` disappears.
      explicitChildNodes: true,
      child: AppSurface(
        clipContent: true,
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
                      url: meal.thumbnailUrl,
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  if (onToggleFavourite != null)
                    PositionedDirectional(
                      top: 10,
                      end: 10,
                      child: _FavouriteButton(
                        mealId: meal.id,
                        mealName: meal.name,
                        isFavourite: isFavourite,
                        onPressed: onToggleFavourite!,
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          meal.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontSize: 15,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          meal.category,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.55,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          formatPrice(meal.price),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontSize: 15,
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  _AddToCartButton(
                    mealId: meal.id,
                    mealName: meal.name,
                    onPressed: onAddToCart,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The round "+" button on every card.
///
/// The identifier embeds the meal id, so an automation run can add a
/// *specific* dish instead of "whatever happens to be first on screen".
class _AddToCartButton extends StatelessWidget {
  const _AddToCartButton({
    required this.mealId,
    required this.mealName,
    required this.onPressed,
  });

  final String mealId;
  final String mealName;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SemanticId(
      id: 'add_to_cart_button_$mealId',
      label: '${context.l10n.addToCart} $mealName',
      button: true,
      child: Material(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(14),
        elevation: 0,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.35),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.add_rounded, color: Colors.white, size: 22),
          ),
        ),
      ),
    );
  }
}

class _FavouriteButton extends StatelessWidget {
  const _FavouriteButton({
    required this.mealId,
    required this.mealName,
    required this.isFavourite,
    required this.onPressed,
  });

  final String mealId;
  final String mealName;
  final bool isFavourite;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isGlass = AppGlassTokens.enabledOf(context);

    return SemanticId(
      id: 'favourite_button_$mealId',
      label: isFavourite
          ? '${context.l10n.removeFromFavourites} $mealName'
          : '${context.l10n.saveToFavourites} $mealName',
      button: true,
      child: Material(
        // A solid white disc reads as a hole in the artwork once the app is in
        // a dark theme, so the well tracks the active surface instead.
        color: isGlass ? AppGlassTokens.wellColor(context) : Colors.white,
        shape: const CircleBorder(),
        elevation: 0,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: isGlass
                ? Border.all(color: AppGlassTokens.wellBorder(context))
                : null,
            boxShadow: theme.brightness == Brightness.dark
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.14),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.all(7),
              child: Icon(
                isFavourite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                size: 18,
                color: isFavourite
                    ? AppColors.hotOffer
                    : theme.colorScheme.onSurface.withValues(alpha: 0.65),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
