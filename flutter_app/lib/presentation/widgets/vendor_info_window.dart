import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../domain/entities/vendor_entity.dart';
import '../extensions/l10n_extension.dart';
import 'app_network_image.dart';

/// Custom contents of the Google Maps marker info window.
///
/// A custom info window (rather than the default) is required by the design:
/// the vendor name, cuisine and star rating have to appear in StreetBite's
/// visual language, and the default bubble cannot be styled that way.
class VendorInfoWindow extends StatelessWidget {
  const VendorInfoWindow({
    super.key,
    required this.vendor,
    required this.onClose,
    this.onDirections,
  });

  final VendorEntity vendor;
  final VoidCallback onClose;
  final VoidCallback? onDirections;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 250,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 52,
                height: 52,
                child: AppNetworkImage(
                  url: vendor.thumbnailUrl,
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vendor.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(height: 1.2),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 16,
                          color: AppColors.rating,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          vendor.rating.toStringAsFixed(1),
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              InkWell(
                key: const ValueKey('vendor_info_close'),
                onTap: onClose,
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.close_rounded, size: 18),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _InfoRow(icon: Icons.restaurant_menu_rounded, text: vendor.cuisine),
          const SizedBox(height: 4),
          _InfoRow(
            icon: Icons.near_me_rounded,
            text: context.trArgs('vendorDistance', {
              'distance': context.formatNumber(vendor.distanceKm),
            }),
          ),
          if (onDirections != null) ...[
            const SizedBox(height: 10),
            SizedBox(
              height: 38,
              child: FilledButton.icon(
                key: const ValueKey('vendor_directions'),
                onPressed: onDirections,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(38),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  textStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                icon: const Icon(Icons.directions_walk_rounded, size: 16),
                label: Text(context.l10n.directions),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
