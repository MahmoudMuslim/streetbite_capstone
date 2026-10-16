import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_theme_mode.dart';
import '../blocs/theme/theme_cubit.dart';
import '../blocs/theme/theme_state.dart';
import '../extensions/l10n_extension.dart';

/// Appearance button that dispatches to [ThemeCubit].
///
/// Exposed as a shared widget so the same affordance (and the same key) is used
/// on the Login screen, the Home AppBar and the Settings screen. It cycles
/// light -> dark -> glass light -> glass dark and always shows the look you are
/// *in*, because with four states an icon promising the next one stops being
/// predictable.
class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key, this.onDarkBackground = false});

  final bool onDarkBackground;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final (icon, label) = switch (state.mode) {
          AppThemeMode.light => (
            Icons.light_mode_rounded,
            context.l10n.lightMode,
          ),
          AppThemeMode.dark => (Icons.dark_mode_rounded, context.l10n.darkMode),
          AppThemeMode.glassLight => (
            Icons.blur_on_rounded,
            '${context.l10n.themeLiquidGlass} · ${context.l10n.lightMode}',
          ),
          AppThemeMode.glassDark => (
            Icons.blur_on_rounded,
            '${context.l10n.themeLiquidGlass} · ${context.l10n.darkMode}',
          ),
        };

        return IconButton(
          key: const ValueKey('theme_toggle_button'),
          tooltip: label,
          color: onDarkBackground ? Colors.white : null,
          onPressed: () => context.read<ThemeCubit>().toggle(),
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            transitionBuilder: (child, animation) => RotationTransition(
              turns: Tween<double>(begin: 0.75, end: 1).animate(animation),
              child: FadeTransition(opacity: animation, child: child),
            ),
            child: Icon(icon, key: ValueKey(state.mode)),
          ),
        );
      },
    );
  }
}
