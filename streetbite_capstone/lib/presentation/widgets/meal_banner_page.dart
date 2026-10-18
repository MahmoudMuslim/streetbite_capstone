import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/string_helpers.dart';
import '../../domain/entities/meal_entity.dart';
import '../extensions/l10n_extension.dart';
import 'app_network_image.dart';

/// One page of the Home screen's featured-meals `PageView`.
///
/// Auto-scrubbing is deliberately **not** used: a carousel that moves on its
/// own fights the user's scroll and makes automated testing flaky. The dots are
/// tappable so navigation stays explicit.
class MealBannerPage extends StatelessWidget {
  const MealBannerPage({
    super.key,
    required this.meal,
    required this.onTap,
    this.isActive = false,
  });

  final MealEntity meal;
  final VoidCallback onTap;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AnimatedScale(
        scale: isActive ? 1 : 0.94,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        child: AnimatedOpacity(
          opacity: isActive ? 1 : 0.75,
          duration: const Duration(milliseconds: 260),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.radius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 22,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: GestureDetector(
              onTap: onTap,
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
                  // Scrim keeps the white text readable over any photo.
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.72),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.local_fire_department_rounded,
                                size: 13,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                context.l10n.hotOffers,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          meal.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            height: 1.15,
                            letterSpacing: -0.4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${meal.area} · ${formatPrice(meal.price)}',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
