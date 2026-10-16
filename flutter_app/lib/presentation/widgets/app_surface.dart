import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../../core/theme/app_glass_tokens.dart';
import '../../core/theme/app_theme.dart';

/// The app's card primitive.
///
/// One call site, two renderings: a real refractive [GlassCard] under the
/// Liquid Glass theme, and the shared [AppTheme.cardDecoration] panel
/// everywhere else. Screens therefore never branch on the theme themselves —
/// they ask for a surface and get whatever the active look calls for, which is
/// also what stops the glass theme from drifting away from light/dark
/// structurally.
class AppSurface extends StatelessWidget {
  const AppSurface({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.margin,
    this.borderRadius = AppTheme.radius,
    this.onTap,
    this.clipContent = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final VoidCallback? onTap;

  /// Clips children to the rounded outline — needed when the surface holds an
  /// image that reaches the edge.
  final bool clipContent;

  @override
  Widget build(BuildContext context) {
    if (AppGlassTokens.enabledOf(context)) {
      final card = GlassCard(
        padding: padding,
        margin: margin,
        clipBehavior: clipContent ? Clip.antiAlias : Clip.none,
        shape: LiquidRoundedSuperellipse(borderRadius: borderRadius),
        child: child,
      );
      return onTap == null ? card : GestureDetector(onTap: onTap, child: card);
    }

    return Container(
      margin: margin,
      clipBehavior: clipContent ? Clip.antiAlias : Clip.none,
      decoration: AppTheme.cardDecoration(context)
          .copyWith(borderRadius: BorderRadius.circular(borderRadius)),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
