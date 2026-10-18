import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'semantic_id.dart';

/// Circular fingerprint shortcut that sits beside the primary Log In button.
///
/// Presentation only: deciding whether a scan can actually sign anyone in is
/// the auth cubit's job, so the same rule applies whether the gate is opened
/// from here or automatically on a cold start.
class BiometricLoginButton extends StatelessWidget {
  const BiometricLoginButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  /// Announced by assistive technology and shown as the tooltip. The caller
  /// resolves it so this widget stays free of the l10n lookup.
  final String label;

  /// `null` while a request is in flight, which is how the button greys itself
  /// out alongside the disabled text fields.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = onPressed != null;
    final tint = isEnabled
        ? AppColors.primary
        : theme.colorScheme.onSurface.withValues(alpha: 0.38);

    return Tooltip(
      message: label,
      child: SemanticId(
        key: const ValueKey('biometric_login_button'),
        id: 'biometric_login_button',
        label: label,
        button: true,
        child: IconButton(
          onPressed: onPressed,
          // Square and 56dp so it reads as a peer of the Log In button.
          constraints: const BoxConstraints.tightFor(width: 56, height: 56),
          padding: EdgeInsets.zero,
          style: IconButton.styleFrom(
            backgroundColor: AppColors.primary.withValues(alpha: 0.12),
            foregroundColor: tint,
            shape: const CircleBorder(),
          ),
          icon: const Icon(Icons.fingerprint_rounded, size: 30),
        ),
      ),
    );
  }
}
