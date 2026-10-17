import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/theme/theme_cubit.dart';
import '../blocs/theme/theme_state.dart';
import '../extensions/app_theme_mode_l10n.dart';
import '../extensions/l10n_extension.dart';
import 'theme_options_sheet.dart';

/// Appearance button that opens the theme options sheet.
///
/// Exposed as a shared widget so the same affordance (and the same key) is used
/// on the three auth screens. It used to cycle light -> dark -> glass light ->
/// glass dark on every tap, which with four looks meant guessing where the next
/// tap lands; the icon still shows the look you are *in*.
class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return IconButton(
          key: const ValueKey('theme_toggle_button'),
          tooltip: context.l10n.themeSheetTitle,
          onPressed: () => showThemeOptionsSheet(context),
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            transitionBuilder: (child, animation) => RotationTransition(
              turns: Tween<double>(begin: 0.75, end: 1).animate(animation),
              child: FadeTransition(opacity: animation, child: child),
            ),
            child: Icon(state.mode.icon, key: ValueKey(state.mode)),
          ),
        );
      },
    );
  }
}
