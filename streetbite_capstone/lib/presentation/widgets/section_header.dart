import 'package:flutter/material.dart';

/// Section heading with an optional trailing action.
///
/// Used for *every* section title on the Home screen, which is what keeps the
/// 24/12 spacing identical between Fastest, Recommended and Hot Offers.
///
/// Both strings are passed in already localized — the widget stays a dumb
/// layout component with no knowledge of the ARB files.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
    this.padding = const EdgeInsets.fromLTRB(20, 24, 12, 12),
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: padding,
      child: Row(
        children: [
          Expanded(child: Text(title, style: theme.textTheme.headlineSmall)),
          if (actionLabel != null && onAction != null)
            TextButton(
              onPressed: onAction,
              child: Text(
                actionLabel!,
                style: TextStyle(color: theme.colorScheme.primary),
              ),
            ),
        ],
      ),
    );
  }
}
