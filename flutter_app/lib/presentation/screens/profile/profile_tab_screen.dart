import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../extensions/l10n_extension.dart';
import '../../widgets/biometric_gate.dart';
import '../../widgets/profile_gate_button.dart';
import 'profile_screen.dart';

/// Bottom-nav wrapper around [ProfileScreen].
///
/// The Profile tab is the *second* door to the same content, and it is locked
/// exactly like the Home AppBar avatar: tapping the tab runs the biometric
/// gate first and only then swaps in the real screen. Centralising the gate
/// here means a new entry point can never accidentally bypass it.
class ProfileTabScreen extends StatefulWidget {
  const ProfileTabScreen({super.key});

  @override
  State<ProfileTabScreen> createState() => _ProfileTabScreenState();
}

class _ProfileTabScreenState extends State<ProfileTabScreen> {
  bool _unlocked = false;

  @override
  Widget build(BuildContext context) {
    if (_unlocked) return const ProfileScreen();

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Theme.of(context).cardColor
                  : Theme.of(context).colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.07),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ProfileGateButton(
                  photoUrl: null,
                  // A bypass is required, not optional. With `false` the tab was a
                  // dead end: a device whose biometrics can never succeed (no
                  // hardware, nothing enrolled, sensor locked out) flashed a
                  // four-second SnackBar and left the user staring at the gate
                  // forever, with no way into their own profile. Viewing a
                  // profile is not a privileged action, so the check is a
                  // speed bump with an off-ramp, never a lock.
                  bypassAllowed: true,
                  onUnlocked: _unlock,
                ),
                const SizedBox(height: 20),
                Text(
                  AppConstants.appName,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  context.l10n.biometricSubtitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                // The avatar above is tappable too, but on its own it read as a
                // static illustration and testers reported the tab as frozen.
                // A labelled button makes the one available action unmistakable.
                FilledButton.icon(
                  key: const ValueKey('profile_unlock_button'),
                  onPressed: _openGate,
                  icon: const Icon(Icons.fingerprint_rounded),
                  label: Text(context.l10n.biometricPromptTitle),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openGate() {
    openBiometricGate(context, onUnlocked: _unlock);
  }

  void _unlock() {
    if (!mounted) return;
    setState(() => _unlocked = true);
  }
}
