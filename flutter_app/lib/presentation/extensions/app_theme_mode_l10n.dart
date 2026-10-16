import 'package:flutter/material.dart';

import '../../core/theme/app_theme_mode.dart';
import '../../l10n/generated/app_localizations.dart';

/// Localized name and glyph for each appearance, in one place.
///
/// The four modes are named in three different affordances (the app-bar button,
/// the Profile row and the theme sheet). A single mapping keeps every one of
/// them localized and stops a new mode from being added with a literal string
/// somewhere.
extension AppThemeModeL10n on AppThemeMode {
  IconData get icon => switch (this) {
    AppThemeMode.light => Icons.light_mode_rounded,
    AppThemeMode.dark => Icons.dark_mode_rounded,
    AppThemeMode.glassLight || AppThemeMode.glassDark => Icons.blur_on_rounded,
  };

  /// Short name used where the surface style is implied, e.g. the segmented
  /// light/dark picker.
  String label(AppLocalizations l10n) => switch (this) {
    AppThemeMode.light => l10n.themeLight,
    AppThemeMode.dark => l10n.themeDark,
    AppThemeMode.glassLight => '${l10n.themeLiquidGlass} · ${l10n.themeLight}',
    AppThemeMode.glassDark => '${l10n.themeLiquidGlass} · ${l10n.themeDark}',
  };

  /// One-line description of what the look actually does to the surfaces.
  String hint(AppLocalizations l10n) => switch (this) {
    AppThemeMode.light => l10n.themeOptionLightHint,
    AppThemeMode.dark => l10n.themeOptionDarkHint,
    AppThemeMode.glassLight => l10n.themeOptionGlassLightHint,
    AppThemeMode.glassDark => l10n.themeOptionGlassDarkHint,
  };

  /// Phrasing for "this is the look you are in", used by tooltips and the
  /// Profile row, where the mode is the *state* rather than a choice.
  String currentLabel(AppLocalizations l10n) => switch (this) {
    AppThemeMode.light => l10n.lightMode,
    AppThemeMode.dark => l10n.darkMode,
    AppThemeMode.glassLight => '${l10n.themeLiquidGlass} · ${l10n.lightMode}',
    AppThemeMode.glassDark => '${l10n.themeLiquidGlass} · ${l10n.darkMode}',
  };
}
