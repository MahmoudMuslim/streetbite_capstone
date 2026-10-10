import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../extensions/l10n_extension.dart';

/// Renders a remote image with a shimmer placeholder and a graceful failure
/// tile.
///
/// Every card in the app goes through this widget, which is why there is
/// exactly one implementation of "what does a broken image look like".
class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
  });

  final String url;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(20);

    Widget child;
    if (url.isEmpty) {
      child = _placeholder(context);
    } else {
      child = CachedNetworkImage(
        imageUrl: url,
        fit: fit,
        width: width,
        height: height,
        placeholder: (_, _) => _placeholder(context),
        errorWidget: (_, _, _) => _placeholder(context),
      );
    }

    return ClipRRect(
      borderRadius: radius,
      child: SizedBox(width: width, height: height, child: child),
    );
  }

  Widget _placeholder(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDark ? AppColors.surfaceDark : AppColors.surface,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.restaurant_rounded,
            color: AppColors.textSecondary.withValues(alpha: 0.6),
            size: 28,
          ),
          const SizedBox(height: 6),
          Text(
            context.l10n.loading,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
