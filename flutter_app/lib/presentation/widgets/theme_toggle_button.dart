import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/theme/theme_cubit.dart';
import '../blocs/theme/theme_state.dart';
import '../extensions/l10n_extension.dart';

/// Sun / moon button that dispatches to [ThemeCubit].
///
/// Exposed as a shared widget so the same affordance (and the same key) is used
/// on the Login screen, the Home AppBar and the Profile settings row.
class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key, this.onDarkBackground = false});

  final bool onDarkBackground;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return IconButton(
          key: const ValueKey('theme_toggle_button'),
          tooltip: state.isDark
              ? context.l10n.lightMode
              : context.l10n.darkMode,
          color: onDarkBackground ? Colors.white : null,
          onPressed: () => context.read<ThemeCubit>().toggle(),
          icon: Icon(
            state.isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
          ),
        );
      },
    );
  }
}
