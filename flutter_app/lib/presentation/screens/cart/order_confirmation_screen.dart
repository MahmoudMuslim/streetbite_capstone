import 'package:flutter/material.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../extensions/l10n_extension.dart';

/// Shown after a successful checkout.
///
/// Deliberately simple: a confirmation icon, the arrival estimate from the
/// brief, and a button back into the Orders tab.
class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.radius),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 132,
                height: 132,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_rounded,
                  size: 78,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                context.l10n.orderPlacedTitle,
                style: theme.textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                context.l10n.orderPlacedMessage,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              FilledButton(
                key: const ValueKey('view_orders_button'),
                onPressed: () => Navigator.of(context)
                    .pushNamedAndRemoveUntil(AppRoutes.home, (route) => false),
                child: Text(context.l10n.viewMyOrders),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
