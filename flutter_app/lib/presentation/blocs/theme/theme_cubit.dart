import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme_state.dart';

/// Owns the light/dark preference and persists it across launches.
///
/// `ThemeMode.system` is deliberately **not** offered as the default: the Figma
/// kit ships two explicit modes and QA needs a deterministic appearance, so the
/// app starts in light mode and only changes when the user taps the toggle.
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit(this._preferences) : super(const ThemeState(ThemeMode.light));

  /// `shared_preferences` key holding the persisted mode.
  static const String storageKey = 'streetbite_theme_mode';

  final SharedPreferences _preferences;

  /// Restores the saved preference; called once from `main()`.
  Future<void> load() async {
    final saved = _preferences.getString(storageKey);
    if (saved == null) return;
    emit(
      ThemeState(
        saved == ThemeMode.dark.name ? ThemeMode.dark : ThemeMode.light,
      ),
    );
  }

  Future<void> toggle() async {
    final next = state.isDark ? ThemeMode.light : ThemeMode.dark;
    emit(ThemeState(next));
    await _preferences.setString(storageKey, next.name);
  }
}
