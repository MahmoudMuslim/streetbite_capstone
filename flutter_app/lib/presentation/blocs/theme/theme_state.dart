import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Light / dark mode preference owned by [ThemeCubit].
class ThemeState extends Equatable {
  const ThemeState(this.themeMode);

  final ThemeMode themeMode;

  bool get isDark => themeMode == ThemeMode.dark;

  ThemeState copyWith({ThemeMode? themeMode}) =>
      ThemeState(themeMode ?? this.themeMode);

  @override
  List<Object?> get props => [themeMode];
}
