import 'package:flutter/material.dart';

/// StreetBite colour palette, taken from the Figma design file.
///
/// Keeping the raw `Color` values in one place (instead of scattering
/// hex literals through widgets) makes the light/dark switch a one-liner.
class AppColors {
  const AppColors._();

  // --- Brand ---------------------------------------------------------------
  /// Primary green used for CTAs, the logo, and the selected bottom-nav item.
  static const Color primary = Color(0xFF00C16A);

  /// Darker green for pressed states and for `ThemeData.primary` on dark mode.
  static const Color primaryDark = Color(0xFF00A85A);

  /// Very light green used for the circular category chips on the home feed.
  static const Color primarySoft = Color(0xFFE6F8F0);

  // --- Neutrals ------------------------------------------------------------
  static const Color background = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF10151A);
  static const Color surface = Color(0xFFF6F7F9);
  static const Color surfaceDark = Color(0xFF1A2027);
  static const Color textPrimary = Color(0xFF12141A);
  static const Color textSecondary = Color(0xFF8A93A3);
  static const Color divider = Color(0xFFE9ECF1);
  static const Color border = Color(0xFFDCE1E8);

  // --- Status --------------------------------------------------------------
  static const Color rating = Color(0xFFFFB020);
  static const Color hotOffer = Color(0xFFFF5A5F);
  static const Color error = Color(0xFFE23D3D);
  static const Color success = Color(0xFF12B76A);

  // --- Splash gradient -----------------------------------------------------
  static const Color splashTop = Color(0xFF00D07A);
  static const Color splashBottom = Color(0xFF00A85A);
}
