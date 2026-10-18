import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../extensions/l10n_extension.dart';

/// Label / value line used by the device-information card.
///
/// `labelKey` is an ARB key rather than a literal so the same row reads
/// "Model" in English and "الموديل" in Arabic.
class InfoRow extends StatelessWidget {
  const InfoRow({
    super.key,
    required this.labelKey,
    required this.value,
    this.valueKeyName,
  });

  final String labelKey;
  final String value;

  /// Stable key exposed to Appium for the value text.
  final String? valueKeyName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _labelFor(context),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.mutedCaption,
              ),
            ),
          ),
          Text(
            value,
            key: valueKeyName == null ? null : ValueKey(valueKeyName),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  /// Tiny lookup table — only three keys exist, so a map is clearer than a
  /// full `switch` and keeps this widget free of an l10n import cycle.
  String _labelFor(BuildContext context) => switch (labelKey) {
    'deviceModel' => context.l10n.deviceModel,
    'deviceOs' => context.l10n.deviceOs,
    'deviceName' => context.l10n.deviceName,
    _ => labelKey,
  };
}
