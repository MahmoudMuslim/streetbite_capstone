import 'dart:ui';

import 'package:equatable/equatable.dart';

/// Runtime language selection owned by [LocaleCubit].
class LocaleState extends Equatable {
  const LocaleState(this.locale);

  /// `null` means "follow the device language".
  final Locale? locale;

  String get languageCode => locale?.languageCode ?? 'en';

  bool get isArabic => languageCode == 'ar';

  LocaleState copyWith({Locale? locale}) => LocaleState(locale ?? this.locale);

  @override
  List<Object?> get props => [locale];
}
