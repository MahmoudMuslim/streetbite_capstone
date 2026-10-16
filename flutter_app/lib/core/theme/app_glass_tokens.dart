import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Tells the widget layer whether the Liquid Glass look is active.
///
/// A [ThemeExtension] rather than a bloc lookup so `core/theme` never depends
/// on `presentation`: any widget — including shared decoration helpers — can
/// ask `Theme.of(context)` and stay correct in widget tests that pump a bare
/// `MaterialApp`.
class AppGlassTokens extends ThemeExtension<AppGlassTokens> {
  const AppGlassTokens({this.enabled = false});

  /// `true` for the glass variants (`glassLight` / `glassDark`).
  final bool enabled;

  /// Reads the tokens, defaulting to "no glass" when a theme omits them.
  static bool enabledOf(BuildContext context) =>
      Theme.of(context).extension<AppGlassTokens>()?.enabled ?? false;

  /// Frosted fill for small wells (icon buttons, category chips) under glass.
  static Color wellColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? AppColors.glassSurfaceStrong
      : AppColors.glassSurfaceLightStrong;

  /// Hairline edge that pairs with [wellColor].
  static Color wellBorder(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? AppColors.glassBorder
      : AppColors.glassBorderLight;

  /// Bottom clearance (dp, measured from the screen edge) the tab content needs
  /// under the Liquid Glass theme.
  ///
  /// `GlassScaffold` lays its body out with `Positioned.fill`, so the capsule
  /// floats *over* the content instead of reserving space for it the way a
  /// Material `NavigationBar` does. The shell publishes this value as
  /// `MediaQuery.padding.bottom` — the same channel Material uses — so screens
  /// can add it as scroll padding: content then runs behind the frost and the
  /// last row still scrolls fully clear of it.
  static const double bottomBarClearance = 104;

  @override
  AppGlassTokens copyWith({bool? enabled}) =>
      AppGlassTokens(enabled: enabled ?? this.enabled);

  @override
  AppGlassTokens lerp(covariant AppGlassTokens? other, double t) =>
      other == null
      ? this
      : AppGlassTokens(enabled: t < 0.5 ? enabled : other.enabled);
}
