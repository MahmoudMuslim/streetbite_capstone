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
  static const Color surface = Color(0xFFF4F6F8);
  static const Color surfaceDark = Color(0xFF1A2027);
  static const Color textPrimary = Color(0xFF12141A);
  static const Color textSecondary = Color(0xFF8A93A3);
  static const Color divider = Color(0xFFE9ECF1);
  static const Color border = Color(0xFFDCE1E8);

  // --- Elevation -----------------------------------------------------------
  /// Ambient + key shadow that lifts white cards off the grey canvas.
  /// Dark mode relies on surface contrast instead, so shadows stay empty.
  static const List<BoxShadow> cardShadow = [
    BoxShadow(color: Color(0x1412141A), blurRadius: 20, offset: Offset(0, 8)),
    BoxShadow(color: Color(0x0A12141A), blurRadius: 2, offset: Offset(0, 1)),
  ];

  // --- Status --------------------------------------------------------------
  static const Color rating = Color(0xFFFFB020);
  static const Color hotOffer = Color(0xFFFF5A5F);
  static const Color error = Color(0xFFE23D3D);
  static const Color success = Color(0xFF12B76A);

  // --- Splash gradient -----------------------------------------------------
  static const Color splashTop = Color(0xFF00D07A);
  static const Color splashBottom = Color(0xFF00A85A);

  // --- Liquid Glass (dark) -------------------------------------------------
  /// Canvas the glass surfaces refract against. Deliberately deep and slightly
  /// blue so the frosted panels read as objects floating over it; a flat white
  /// backdrop would make blur invisible.
  static const Color glassCanvasTop = Color(0xFF080D18);
  static const Color glassCanvasBottom = Color(0xFF111C2E);

  /// The two aurora blobs painted behind the canvas gradient.
  static const Color glassAuroraGreen = Color(0xFF00C16A);
  static const Color glassAuroraBlue = Color(0xFF2E6BFF);

  /// Translucent panel fill + hairline edge used where a real glass widget is
  /// not available (or would be too expensive), so surfaces still match.
  static const Color glassSurface = Color(0x14FFFFFF);
  static const Color glassSurfaceStrong = Color(0x22FFFFFF);
  static const Color glassBorder = Color(0x26FFFFFF);

  static const Color glassTextPrimary = Color(0xFFF2F6FC);
  static const Color glassTextSecondary = Color(0xFF9DAABF);

  // --- Liquid Glass (light) ------------------------------------------------
  /// Same frosted treatment over a pale canvas: the panels are white-tinted
  /// glass instead of dark-tinted glass, so blur still reads on a bright page.
  static const Color glassCanvasTopLight = Color(0xFFDCE9F7);
  static const Color glassCanvasBottomLight = Color(0xFFEAF3EC);

  static const Color glassSurfaceLight = Color(0x8CFFFFFF);
  static const Color glassSurfaceLightStrong = Color(0xB3FFFFFF);
  static const Color glassBorderLight = Color(0x99FFFFFF);

  static const Color glassTextPrimaryLight = Color(0xFF12222E);
  static const Color glassTextSecondaryLight = Color(0xFF54687A);
}
