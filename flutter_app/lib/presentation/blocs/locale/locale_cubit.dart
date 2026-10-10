import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'locale_state.dart';

/// Switches the app between English and Arabic **at runtime**.
///
/// The choice is persisted so the next launch opens in the same language, and
/// the emitted [Locale] is fed straight into `MaterialApp.locale`, which makes
/// `flutter gen-l10n` re-resolve every string without a restart.
class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit(this._preferences) : super(const LocaleState(Locale('en')));

  static const String storageKey = 'streetbite_locale';

  final SharedPreferences _preferences;

  /// Locales StreetBite ships translations for.
  static const List<Locale> supportedLocales = [Locale('en'), Locale('ar')];

  /// Restores the saved language; called once from `main()`.
  Future<void> load() async {
    final saved = _preferences.getString(storageKey);
    if (saved == null) return;
    emit(LocaleState(Locale(saved)));
  }

  Future<void> toggle() async {
    final next = state.isArabic ? const Locale('en') : const Locale('ar');
    emit(LocaleState(next));
    await _preferences.setString(storageKey, next.languageCode);
  }

  Future<void> setLocale(Locale locale) async {
    if (!supportedLocales.any(
      (item) => item.languageCode == locale.languageCode,
    )) {
      return;
    }
    emit(LocaleState(locale));
    await _preferences.setString(storageKey, locale.languageCode);
  }
}
