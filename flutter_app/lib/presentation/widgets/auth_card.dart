import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

/// Rounded surface that groups the fields of a form, matching the 20px radius
/// used by every card in the Figma kit.
class AuthCard extends StatelessWidget {
  const AuthCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppTheme.radius),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? theme.cardColor
            : theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        border: theme.brightness == Brightness.dark
            ? null
            : Border.all(color: theme.dividerColor.withValues(alpha: 0.6)),
      ),
      child: child,
    );
  }
}
