import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/string_helpers.dart';
import '../../domain/entities/meal_entity.dart';
import 'app_network_image.dart';

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

    return SizedBox(
      width: 150,
      child: Card(
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
                    AppNetworkImage(
                      key: ValueKey('hot_offer_image_${meal.id}'),
                      url: meal.thumbnailUrl,
                      borderRadius: BorderRadius.zero,
                    ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.hotOffer,
                          borderRadius: BorderRadius.circular(20),
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
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      meal.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(height: 1.2),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatPrice(meal.price),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w800,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
