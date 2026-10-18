import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_theme_mode.dart';

/// Appearance preference owned by [ThemeCubit].
///
/// Holds the app's own [AppThemeMode] rather than Flutter's [ThemeMode] so the
/// third "Liquid Glass" look can exist without leaking a rendering detail into
/// every screen: [themeMode] and [isDark] translate it back for `MaterialApp`
/// and for the widgets that only care about brightness.
class ThemeState extends Equatable {
  const ThemeState(this.mode);

  final AppThemeMode mode;

  ThemeMode get themeMode => mode.materialMode;

  bool get isDark => mode.isDark;

  bool get isLiquidGlass => mode.isLiquidGlass;

  ThemeState copyWith({AppThemeMode? mode}) => ThemeState(mode ?? this.mode);

  @override
  List<Object?> get props => [mode];
}
