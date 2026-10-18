import 'package:flutter/widgets.dart';

import 'language_toggle_button.dart';
import 'theme_toggle_button.dart';

/// The appearance and language switchers that head every screen reachable
/// without a session.
///
/// Login, Sign Up and the fingerprint gate all offer exactly these two, so the
/// list lives here instead of being re-typed by each screen.
const List<Widget> authAppBarActions = [
  ThemeToggleButton(),
  LanguageToggleButton(),
  SizedBox(width: 8),
];
