import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/theme/app_glass_tokens.dart';

/// Wraps placeholder shapes in the shimmer sweep.
///
/// One sweep per screen rather than per box: a single animated gradient over the
/// whole skeleton is what makes it read as "one thing loading", and it costs one
/// repaint boundary instead of a dozen.
class ShimmerScope extends StatelessWidget {
  const ShimmerScope({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final glass = AppGlassTokens.enabledOf(context);
    final isDark = glass || Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: glass
          ? (isDark ? const Color(0xFF1B2637) : const Color(0xFFDCE6F0))
          : isDark
          ? const Color(0xFF212B37)
          : const Color(0xFFE1E6ED),
      highlightColor: glass
          ? (isDark ? const Color(0xFF2C3B52) : const Color(0xFFF4FAFF))
          : isDark
          ? const Color(0xFF2E3A49)
          : const Color(0xFFF7F9FC),
      period: const Duration(milliseconds: 1400),
      // Placeholders must never eat a tap: a skeleton that looks like a card but
      // swallows the press is how "the app froze" bug reports start.
      child: IgnorePointer(
        child: Padding(padding: padding ?? EdgeInsets.zero, child: child),
      ),
    );
  }
}
