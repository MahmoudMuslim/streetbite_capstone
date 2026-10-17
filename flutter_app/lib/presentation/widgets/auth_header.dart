import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../extensions/l10n_extension.dart';

/// Large title + supporting sentence at the top of Login / Sign Up.
class AuthHeader extends StatelessWidget {
  const AuthHeader({
    super.key,
    required this.titleKey,
    required this.subtitleKey,
  });

  final String titleKey;
  final String subtitleKey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.trKey(titleKey), style: theme.textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text(
          context.trKey(subtitleKey),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.mutedCaption,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
