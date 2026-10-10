import 'package:flutter/material.dart';

import '../../domain/entities/payment.dart';
import '../extensions/l10n_extension.dart';

/// Radio list of the available payment strategies.
///
/// The widget is written against the [PaymentMethod] **interface** only — it
/// never mentions `CashPayment` or `CardPayment`. Adding a wallet payment means
/// registering it in [PaymentFactory] and this selector renders it with zero
/// changes here. That is Dependency Inversion paying for itself.
class PaymentMethodSelector extends StatelessWidget {
  const PaymentMethodSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final PaymentMethod selected;
  final ValueChanged<PaymentMethod> onChanged;

  /// Every strategy the app currently supports.
  static List<PaymentMethod> get _options => const [
    CashPayment(),
    CardPayment(),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _options.map((method) {
        final isSelected = method.type == selected.type;
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: InkWell(
            key: ValueKey('payment_option_${method.type.key}'),
            onTap: () => onChanged(method),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).dividerColor,
                  width: isSelected ? 1.8 : 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    method is CardPayment
                        ? Icons.credit_card_rounded
                        : Icons.payments_outlined,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.trKey(method.labelKey),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          context.trKey(method.descriptionKey),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isSelected
                        ? Icons.radio_button_checked_rounded
                        : Icons.radio_button_unchecked_rounded,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).disabledColor,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
