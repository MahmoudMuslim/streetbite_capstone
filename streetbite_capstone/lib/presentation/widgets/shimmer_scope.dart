import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_glass_tokens.dart';

/// Wraps placeholder shapes in the shimmer sweep.
///
/// One sweep per screen rather than per box: a single animated gradient over the
/// whole skeleton is what makes it read as "one thing loading", and it costs one
/// repaint boundary instead of a dozen.
class ShimmerScope extends StatelessWidget {
  const ShimmerScope({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final glass = AppGlassTokens.enabledOf(context);
    final isDark = glass || Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: glass
          ? (isDark
                ? AppColors.shimmerBaseGlassDark
                : AppColors.shimmerBaseGlass)
          : isDark
          ? AppColors.shimmerBaseDark
          : AppColors.shimmerBase,
      highlightColor: glass
          ? (isDark
                ? AppColors.shimmerHighlightGlassDark
                : AppColors.shimmerHighlightGlass)
          : isDark
          ? AppColors.shimmerHighlightDark
          : AppColors.shimmerHighlight,
      period: const Duration(milliseconds: 1400),
      // Placeholders must never eat a tap: a skeleton that looks like a card but
      // swallows the press is how "the app froze" bug reports start.
      child: IgnorePointer(child: child),
    );
  }
}
