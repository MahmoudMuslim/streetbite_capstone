import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_glass_tokens.dart';
import '../../../core/utils/string_helpers.dart';
import '../../../domain/entities/meal_entity.dart';
import '../extensions/l10n_extension.dart';
import 'app_network_image.dart';
import 'app_surface.dart';
import 'cart_count_badge.dart';
import 'cart_line_action.dart';
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
    this.isFavourite = false,
    this.onToggleFavourite,
  });

  final MealEntity meal;
  final VoidCallback onTap;

  final bool isFavourite;
  final VoidCallback? onToggleFavourite;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SemanticId(
      id: 'meal_card_${meal.id}',
      label: meal.name,
      // The card is a tap target, and Android only keeps a node's identifier
      // once it flattens the subtree if that node declares itself actionable —
      // which is why the category chips and the cart buttons pass `button` too.
      button: true,
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
                  // Leading corner: the favourite toggle already owns the
                  // trailing one, and "start" is the first thing both LTR and
                  // RTL readers scan.
                  PositionedDirectional(
                    top: 10,
                    start: 10,
                    child: CartCountBadge(mealId: meal.id),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
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
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          formatPrice(meal.price),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontSize: 14,
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      CartLineAction(meal: meal),
                    ],
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
