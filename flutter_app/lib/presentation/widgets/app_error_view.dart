import 'package:flutter/material.dart';

import '../extensions/l10n_extension.dart';

/// Friendly full-screen error state used by every screen that can fail.
///
/// Showing a *message plus a retry action* (never a raw exception) is how
/// StreetBite satisfies the "every error must be caught and displayed as a
/// friendly UI message" requirement.
class AppErrorView extends StatelessWidget {
  const AppErrorView({
    super.key,
    required this.messageKey,
    this.onRetry,
    this.icon = Icons.wifi_off_rounded,
  });

  /// ARB key resolved through `context.trKey(...)`.
  final String messageKey;

  /// `null` hides the retry button (used for validation-style errors).
  final VoidCallback? onRetry;

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 44, color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 24),
            Text(
              context.l10n.somethingWentWrong,
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              context.trKey(messageKey),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 28),
              SizedBox(
                width: 220,
                child: FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(context.l10n.retry),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
