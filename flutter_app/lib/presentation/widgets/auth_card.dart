import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

/// Rounded surface that groups the fields of a form, matching the 20px radius
/// used by every card in the Figma kit.
class AuthCard extends StatelessWidget {
  const AuthCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.radius),
      decoration: AppTheme.cardDecoration(context),
      child: child,
    );
  }
}
