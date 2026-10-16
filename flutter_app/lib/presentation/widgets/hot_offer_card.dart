import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/string_helpers.dart';
import '../../domain/entities/meal_entity.dart';
import 'app_network_image.dart';
import 'app_surface.dart';

/// One tile of the horizontal "Hot Offers" strip.
///
/// Intentionally a *different* card shape from [MealCard] (square image on top,
/// discount ribbon) so the strip is visually distinguishable from the grid and
/// matches the Figma kit's `Home` screen.
class HotOfferCard extends StatelessWidget {
  const HotOfferCard({
    super.key,
    required this.meal,
    required this.onTap,
    required this.discountPercent,
  });

  final MealEntity meal;
  final VoidCallback onTap;

  /// Position of the offer inside the strip (1-based) used for the ribbon.
  final int discountPercent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final discounted = meal.price * (1 - discountPercent / 100);

    return SizedBox(
      width: 156,
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
                  AppNetworkImage(
                    key: ValueKey('hot_offer_image_${meal.id}'),
                    url: meal.thumbnailUrl,
                    borderRadius: BorderRadius.zero,
                  ),
                  PositionedDirectional(
                    top: 10,
                    start: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.hotOffer,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.hotOffer.withValues(alpha: 0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        '-$discountPercent%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    meal.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontSize: 14,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          formatPrice(discounted),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontSize: 14,
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          formatPrice(meal.price),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 11,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.45,
                            ),
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ),
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
