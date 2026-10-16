import 'package:flutter/material.dart';

/// The four appearances StreetBite ships.
///
/// Appearance is two independent axes — brightness (light / dark) and surface
/// style (Material / Liquid Glass) — collapsed into one enum so a single
/// persisted string and a single `ThemeCubit` state drive both. It still maps
/// onto a [ThemeMode] for `MaterialApp`: glass is not a brightness of its own,
/// it is a rendering layer that exists in *both* brightnesses, and every widget
/// that branches on `Brightness` keeps working without knowing glass exists.
enum AppThemeMode {
  light,
  dark,
  glassLight,
  glassDark;

  bool get isDark => this == dark || this == glassDark;

  bool get isLiquidGlass => this == glassLight || this == glassDark;

  ThemeMode get materialMode => isDark ? ThemeMode.dark : ThemeMode.light;

  /// Next mode when the user taps the single AppBar toggle, so every look is
  /// discoverable without opening Settings.
  AppThemeMode get next => switch (this) {
    light => dark,
    dark => glassLight,
    glassLight => glassDark,
    glassDark => light,
  };

  /// This appearance with the surface style replaced, brightness kept.
  AppThemeMode withGlass(bool glass) => switch ((glass, isDark)) {
    (true, true) => glassDark,
    (true, false) => glassLight,
    (false, true) => dark,
    (false, false) => light,
  };

  /// This appearance with the brightness replaced, surface style kept.
  AppThemeMode withDark(bool useDark) => switch ((useDark, isLiquidGlass)) {
    (true, true) => glassDark,
    (true, false) => dark,
    (false, true) => glassLight,
    (false, false) => light,
  };

  /// Parses the persisted name, falling back to [light] on an unknown value so
  /// a rename or a corrupted preference can never brick start-up. The pre-1.1
  /// name `liquidGlass` meant the dark variant and migrates to it.
  static AppThemeMode fromName(String? value) {
    if (value == 'liquidGlass') return glassDark;
    return AppThemeMode.values.firstWhere(
      (mode) => mode.name == value,
      orElse: () => AppThemeMode.light,
    );
  }
}
