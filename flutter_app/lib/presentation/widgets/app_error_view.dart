import 'package:flutter/material.dart';

import '../extensions/l10n_extension.dart';
import 'message_panel.dart';

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
    return MessagePanel(
      icon: icon,
      title: context.l10n.somethingWentWrong,
      body: context.trKey(messageKey),
      action: onRetry == null
          ? null
          : FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(context.l10n.retry),
            ),
    );
  }
}
