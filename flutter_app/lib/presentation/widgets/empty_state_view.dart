import 'package:flutter/material.dart';

import '../extensions/l10n_extension.dart';

/// Shared "nothing here yet" panel used by the Cart, the Favourites list and
/// the Order history.
///
/// Centralising it guarantees all three screens use the same icon, spacing and
/// copy hierarchy — and that a wording change is a one-line edit.
class EmptyStateView extends StatelessWidget {
  const EmptyStateView({
    super.key,
    required this.titleKey,
    required this.bodyKey,
    required this.icon,
    this.actionLabelKey,
    this.onAction,
  });

  final String titleKey;
  final String bodyKey;
  final IconData icon;

  /// ARB key of the optional call-to-action label.
  final String? actionLabelKey;

  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 52, color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 24),
            Text(
              context.trKey(titleKey),
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              context.trKey(bodyKey),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabelKey != null && onAction != null) ...[
              const SizedBox(height: 28),
              SizedBox(
                width: 240,
                child: FilledButton(
                  onPressed: onAction,
                  child: Text(context.trKey(actionLabelKey!)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
