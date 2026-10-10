import 'package:flutter/material.dart';

import '../extensions/l10n_extension.dart';

/// Centred `CircularProgressIndicator` with a localized caption.
///
/// A bare spinner with no context is the most common source of "is it broken?"
/// support tickets, so StreetBite always pairs the indicator with a sentence.
class AppLoadingView extends StatelessWidget {
  const AppLoadingView({super.key, this.messageKey});

  /// Optional ARB key; defaults to the generic "Loading" caption.
  final String? messageKey;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            context.trKey(messageKey ?? 'loading'),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface
                  .withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
