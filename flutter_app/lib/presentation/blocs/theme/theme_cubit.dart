import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/theme/app_theme_mode.dart';
import 'theme_state.dart';

/// Owns the appearance preference and persists it across launches.
///
/// `ThemeMode.system` is deliberately **not** offered: the design ships three
/// explicit looks and QA needs a deterministic appearance, so the app starts in
/// light mode and only changes when the user asks.
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit(this._preferences) : super(const ThemeState(AppThemeMode.light));

  /// `shared_preferences` key holding the persisted mode.
  static const String storageKey = 'streetbite_theme_mode';

  final SharedPreferences _preferences;

  /// Restores the saved preference; called once from `main()`.
  Future<void> load() async {
    final saved = _preferences.getString(storageKey);
    if (saved == null) return;
    emit(ThemeState(AppThemeMode.fromName(saved)));
  }

  /// Explicit pick from the Settings screen.
  Future<void> setMode(AppThemeMode mode) async {
    if (mode == state.mode) return;
    emit(ThemeState(mode));
    await _preferences.setString(storageKey, mode.name);
  }

  /// Single-tap cycle used by the AppBar toggle: light -> dark -> glass.
  Future<void> toggle() => setMode(state.mode.next);
}
