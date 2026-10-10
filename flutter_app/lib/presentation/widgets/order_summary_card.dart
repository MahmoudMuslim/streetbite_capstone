import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/string_helpers.dart';
import '../../domain/usecases/calculate_order_totals.dart';
import '../extensions/l10n_extension.dart';

/// The sticky money panel at the bottom of the Cart screen.
///
/// Every number comes from [OrderTotals], produced by the
/// `CalculateOrderTotals` use case — the widget never does arithmetic, which
/// is what guarantees the displayed total is exactly the total that gets
/// written to Firestore.
class OrderSummaryCard extends StatelessWidget {
  const OrderSummaryCard({
    super.key,
    required this.totals,
    required this.child,
  });

  final OrderTotals totals;

  /// The checkout actions rendered under the totals.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? theme.cardColor
            : theme.colorScheme.surfaceContainerLowest,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppTheme.radius,
            20,
            AppTheme.radius,
            12,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.l10n.orderSummary,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              _SummaryRow(
                label: context.l10n.subtotal,
                value: formatPrice(totals.subtotal),
              ),
              _SummaryRow(
                label: context.l10n.deliveryFee,
                value: totals.hasFreeDelivery
                    ? context.l10n.free
                    : formatPrice(totals.deliveryFee),
                highlight: totals.hasFreeDelivery,
              ),
              _SummaryRow(
                label: context.l10n.serviceFee,
                value: formatPrice(totals.serviceFee),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Divider(height: 1),
              ),
              _SummaryRow(
                label: context.l10n.total,
                value: formatPrice(totals.total),
                emphasised: true,
              ),
              const SizedBox(height: 12),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.emphasised = false,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool emphasised;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = emphasised
        ? theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w800,
          )
        : theme.textTheme.bodyMedium;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: style?.copyWith(
              color: emphasised
                  ? null
                  : theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          Text(
            value,
            style: style?.copyWith(
              color: highlight ? AppColors.success : null,
              fontWeight: emphasised || highlight ? FontWeight.w800 : null,
            ),
          ),
        ],
      ),
    );
  }
}
