import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../extensions/l10n_extension.dart';
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ProfileGateButton(
                photoUrl: null,
                bypassAllowed: false,
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
            ],
          ),
        ),
      ),
    );
  }

  void _unlock() {
    if (!mounted) return;
    setState(() => _unlocked = true);
  }
}
