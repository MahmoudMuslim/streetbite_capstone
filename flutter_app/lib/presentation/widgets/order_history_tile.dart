import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/string_helpers.dart';
import '../../domain/entities/order_entity.dart';
import '../extensions/l10n_extension.dart';

/// One past/present order in the Profile history and the Orders tab.
///
/// The tile mirrors the Figma "Orders" design: thumbnail, vendor line, and a
/// muted "N items · Today" sub-line.
class OrderHistoryTile extends StatelessWidget {
  const OrderHistoryTile({super.key, required this.order});

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final firstItem = order.items.isEmpty ? null : order.items.first;
    final isActive = order.status == OrderStatus.active;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.takeout_dining_rounded,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isActive)
                  Row(
                    children: [
                      const Icon(
                        Icons.circle,
                        size: 8,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        context.l10n.orderPlacedMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  )
                else
                  Text(
                    _firstMealName(order, context),

                    style: theme.textTheme.titleSmall,
                  ),
                const SizedBox(height: 4),
                Text(
                  '${context.itemCount(order.itemCount)} · '
                  '${context.trArgs('paidWith', {'method': context.trKey(order.payment.labelKey)})} · '
                  '${formatPrice(order.total)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                  ),
                ),
                if (firstItem != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    _firstMealName(order, context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(
                        alpha: 0.55,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Falls back to a neutral label when an order somehow has no lines.
  String _firstMealName(OrderEntity order, BuildContext context) =>
      order.items.isEmpty ? context.l10n.cart : order.items.first.meal.name;
}
