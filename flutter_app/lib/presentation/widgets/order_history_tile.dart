import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/string_helpers.dart';
import '../../domain/entities/order_entity.dart';
import '../extensions/l10n_extension.dart';
import 'app_surface.dart';
import 'semantic_id.dart';

/// One past/present order in the Profile history and the Orders tab.
///
/// The tile mirrors the Figma "Orders" design: thumbnail, vendor line, and a
/// muted "N items · Today" sub-line.
///
/// It is also a button: [onTap] opens the receipt. Because every row in both
/// lists is clickable, the chevron sits in its own fixed column rather than
/// being appended to a label — trailing text is the first thing to get clipped
/// once the Arabic payment wording stretches the meta line.
class OrderHistoryTile extends StatelessWidget {
  const OrderHistoryTile({super.key, required this.order, this.onTap});

  final OrderEntity order;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final firstItem = order.items.isEmpty ? null : order.items.first;
    final isActive = order.status == OrderStatus.active;

    return SemanticId(
      id: 'order_tile_${order.id}',
      button: onTap != null,
      label:
          '${context.l10n.orderNumber(order.id)} · '
          '${context.itemCount(order.itemCount)} · ${formatPrice(order.total)}',
      child: AppSurface(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                // Tinted from the accent rather than a fixed pale green, so the
                // well still reads on the dark and glass canvases.
                color: theme.colorScheme.primary.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.takeout_dining_rounded,
                color: theme.colorScheme.primary,
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
                        Expanded(
                          child: Text(
                            context.l10n.orderPreparing,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      _firstMealName(order, context),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall,
                    ),
                  const SizedBox(height: 4),
                  // The meta line concatenates three translated fragments, and the
                  // Arabic payment labels are markedly longer than the English
                  // ones — clamping it is what keeps the tile inside the screen.
                  Text(
                    '${context.itemCount(order.itemCount)} · '
                    '${context.trArgs('paidWith', {'method': context.trKey(order.payment.labelKey)})} · '
                    '${formatPrice(order.total)}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(
                        alpha: 0.55,
                      ),
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
            if (onTap != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.35),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Falls back to a neutral label when an order somehow has no lines.
  String _firstMealName(OrderEntity order, BuildContext context) =>
      order.items.isEmpty ? context.l10n.cart : order.items.first.meal.name;
}
