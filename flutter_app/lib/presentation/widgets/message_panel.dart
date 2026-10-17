import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

/// The panel behind every "state shown instead of content": an accent circle
/// with an icon, a heading, a supporting line and one optional action.
///
/// [AppErrorView] and [EmptyStateView] are the two vocabularies on top of it, so
/// a failure and an empty list are visibly the same kind of screen.
class MessagePanel extends StatelessWidget {
  const MessagePanel({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    this.action,
  });

  final IconData icon;
  final String title;
  final String body;

  /// Rendered inside a fixed-width slot; `null` leaves the panel action-free.
  final Widget? action;

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
              title,
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              body,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.mutedCaption,
              ),
              textAlign: TextAlign.center,
            ),
            if (action != null) ...[
              const SizedBox(height: 28),
              SizedBox(width: 240, child: action),
            ],
          ],
        ),
      ),
    );
  }
}
