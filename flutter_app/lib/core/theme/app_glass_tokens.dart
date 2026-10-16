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

  @override
  AppGlassTokens copyWith({bool? enabled}) =>
      AppGlassTokens(enabled: enabled ?? this.enabled);

  @override
  AppGlassTokens lerp(covariant AppGlassTokens? other, double t) =>
      other == null
      ? this
      : AppGlassTokens(enabled: t < 0.5 ? enabled : other.enabled);
}
