import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/locale/locale_cubit.dart';
import '../blocs/locale/locale_state.dart';
import '../extensions/l10n_extension.dart';

/// Compact EN / AR switch shown in every AppBar and on the splash screen.
///
/// Having one reusable control means the language can always be changed
/// *without* going through Settings — a hard requirement for an Arabic tester
/// running the Appium suite.
class LanguageToggleButton extends StatelessWidget {
  const LanguageToggleButton({
    super.key,
    this.onDarkBackground = false,
    this.style,
  });

  /// `true` on the green splash gradient, where the border/text must be white.
  final bool onDarkBackground;

  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, state) {
        final isArabic = state.isArabic;
        return Semantics(
          button: true,
          label: context.l10n.language,
          child: SizedBox(
            height: 36,
            child: OutlinedButton(
              key: const ValueKey('language_toggle_button'),
              onPressed: () => context.read<LocaleCubit>().toggle(),
              style:
                  style ??
                  OutlinedButton.styleFrom(
                    minimumSize: const Size(64, 36),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    side: BorderSide(
                      color: onDarkBackground
                          ? Colors.white.withValues(alpha: 0.7)
                          : Theme.of(context).colorScheme.primary
                                .withValues(alpha: 0.4),
                    ),
                    foregroundColor: onDarkBackground ? Colors.white : null,
                    textStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
              child: Text(isArabic ? 'ع' : 'EN'),
            ),
          ),
        );
      },
    );
  }
}
