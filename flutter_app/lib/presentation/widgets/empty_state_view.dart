import 'package:flutter/material.dart';

import '../extensions/l10n_extension.dart';
import 'message_panel.dart';

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
    return MessagePanel(
      icon: icon,
      title: context.trKey(titleKey),
      body: context.trKey(bodyKey),
      action: actionLabelKey == null || onAction == null
          ? null
          : FilledButton(
              onPressed: onAction,
              child: Text(context.trKey(actionLabelKey!)),
            ),
    );
  }
}
