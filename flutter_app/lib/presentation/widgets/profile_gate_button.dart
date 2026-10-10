import 'dart:io';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../extensions/l10n_extension.dart';
import 'biometric_gate.dart';

/// Circular avatar that launches the biometric gate when tapped.
///
/// Living in its own file keeps the Home screen AppBar to a single
/// [ProfileGateButton] while the prompt, the failure dialogs and the bypass
/// logic all stay reusable in `biometric_gate.dart`.
class ProfileGateButton extends StatelessWidget {
  const ProfileGateButton({
    super.key,
    required this.photoUrl,
    required this.onUnlocked,
    this.bypassAllowed = true,
    this.onBypass,
  });

  final String? photoUrl;
  final VoidCallback onUnlocked;

  /// Profile data is not destructive, so a failed check may be bypassed.
  final bool bypassAllowed;

  final VoidCallback? onBypass;

  @override
  Widget build(BuildContext context) {
    final url = photoUrl;

    return Semantics(
      button: true,
      label: context.l10n.profile,
      child: GestureDetector(
        key: const ValueKey('profile_gate_button'),
        onTap: () => openBiometricGate(
          context,
          onUnlocked: onUnlocked,
          bypassAllowed: bypassAllowed,
          onBypass: onBypass,
        ),
        child: Container(
          width: 42,
          height: 42,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primarySoft,
            border: Border.all(color: AppColors.primary, width: 2),
            image: (url == null || url.isEmpty)
                ? null
                : DecorationImage(
                    image: _avatarProvider(url),
                    fit: BoxFit.cover,
                  ),
          ),
          child: (url == null || url.isEmpty)
              ? const Icon(Icons.person_rounded, color: AppColors.primaryDark)
              : null,
        ),
      ),
    );
  }

  /// The photo can be a local file (straight from `image_picker`) or a remote
  /// URL (read back from Firestore), and both must render — decided once here
  /// so no other widget has to branch on the scheme.
  static ImageProvider _avatarProvider(String value) =>
      value.startsWith('http') ? NetworkImage(value) : FileImage(File(value));
}
