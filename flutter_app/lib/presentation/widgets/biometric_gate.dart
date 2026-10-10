import 'package:flutter/material.dart';

import '../../data/services/biometric_service.dart';
import '../extensions/l10n_extension.dart';

/// Runs the fingerprint / face check and decides what happens next.
///
/// Split out of [ProfileGateButton] so the gate can be triggered from a button,
/// a long-press, or a settings row without duplicating any of the dialog
/// logic. The policy is:
///
/// * **success** -> [onUnlocked]
/// * **failure / cancel / no hardware** -> a dialog explaining the reason,
///   with a "continue without biometrics" escape when `bypassAllowed`.
/// * `await`s the prompt, so a caller can sequence navigation after it.
Future<void> openBiometricGate(
  BuildContext context, {
  required VoidCallback onUnlocked,
  bool bypassAllowed = true,
  VoidCallback? onBypass,
}) async {
  final service = BiometricService();

  final result = await service.authenticate(
    reason: BiometricGateReason.profile,
  );

  if (!context.mounted) return;

  if (result.isSuccess) {
    onUnlocked();
    return;
  }

  if (!bypassAllowed) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          key: const ValueKey('biometric_error_snackbar'),
          content: Text(context.trKey(result.messageKey!)),
        ),
      );
    return;
  }

  final bypass = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      key: const ValueKey('biometric_dialog'),
      icon: const Icon(Icons.fingerprint_rounded, size: 42),
      title: Text(context.l10n.biometricPromptTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(context.l10n.biometricSubtitle, textAlign: TextAlign.center),
          if (result.messageKey != null) ...[
            const SizedBox(height: 12),
            Text(
              context.trKey(result.messageKey!),
              textAlign: TextAlign.center,
              style: Theme.of(dialogContext).textTheme.bodySmall,
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text(context.l10n.skip),
        ),
        FilledButton(
          key: const ValueKey('biometric_continue_button'),
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text(context.l10n.useInstead),
        ),
      ],
    ),
  );

  if (bypass == true) {
    onBypass?.call();
    onUnlocked();
  }
}

/// Reason strings passed to the OS biometric prompt.
class BiometricGateReason {
  const BiometricGateReason._();

  static const String profile = 'Unlock your StreetBite profile';
}
