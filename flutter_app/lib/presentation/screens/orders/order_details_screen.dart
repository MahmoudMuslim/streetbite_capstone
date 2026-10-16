import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/string_helpers.dart';
import '../../../domain/entities/cart_item_entity.dart';
import '../../../domain/entities/order_entity.dart';
import '../../../domain/entities/payment.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/cart/cart_event.dart';
import '../../extensions/l10n_extension.dart';
import '../../widgets/app_network_image.dart';
import '../../widgets/app_surface.dart';
import '../../widgets/cart_badge.dart';
import '../../widgets/empty_state_view.dart';
import '../../widgets/semantic_id.dart';

/// The receipt behind a row in the Orders tab (and in the Profile history).
///
/// Like `MealDetailsScreen`, the **entity itself** travels as a route argument:
/// an order is an immutable snapshot of what was bought, so the receipt renders
/// instantly, works offline, and can never disagree with the list it opened
/// from. Nothing is re-fetched here — that would rewrite history if a vendor
/// later changed a price.
///
/// The screen therefore only ever shows fields the order actually carries
/// (lines, money breakdown, payment strategy, placed-at, status). A delivery
/// address or an ETA is deliberately *not* invented: `OrderEntity` has no such
/// column, and a receipt that fabricates either would be worse than none.
class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key, required this.order});

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text(context.l10n.orderDetails),
        actions: [
          IconButton(
            key: const ValueKey('order_details_open_cart_button'),
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.cart),
            icon: CartBadge(child: const Icon(Icons.shopping_bag_outlined)),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    // Defensive: `AppRouter` hands us a placeholder order when a deep link
    // arrives with no argument. Showing "Order #" plus a January-1970 timestamp
    // would read as a bug, so the empty panel is the honest answer.
    if (order.id.isEmpty) {
      return EmptyStateView(
        titleKey: 'orderHistoryEmpty',
        bodyKey: 'orderHistoryEmptyBody',
        icon: Icons.receipt_long_outlined,
        actionLabelKey: 'browseMenu',
        onAction: () =>
            Navigator.of(context)
                .pushNamedAndRemoveUntil(AppRoutes.home, (_) => false),
      );
    }

    return Responsive.constrainWidth(
      context,
      child: ListView(
        key: const ValueKey('order_details_list'),
        padding: EdgeInsets.fromLTRB(
          Responsive.horizontalPadding(context),
          12,
          Responsive.horizontalPadding(context),
          24 + Responsive.bottomBarClearance(context),
        ),
        children: [
          _ReceiptHeader(order: order),
          if (order.items.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: EmptyStateView(
                titleKey: 'orderHistoryEmpty',
                bodyKey: 'orderHistoryEmptyBody',
                icon: Icons.receipt_long_outlined,
                actionLabelKey: 'browseMenu',
                onAction: () =>
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(AppRoutes.home, (_) => false),
              ),
            )
          else ...[
            const SizedBox(height: 20),
            _SectionHeader(label: context.l10n.orderItemsTitle),
            for (final item in order.items)
              _OrderLine(
                item: item,
                onOpenMeal: () => Navigator.of(context)
                    .pushNamed(AppRoutes.mealDetails, arguments: [item.meal]),
              ),
            const SizedBox(height: 16),
            _SectionHeader(label: context.l10n.orderSummary),
            _MoneyBreakdown(order: order),
            const SizedBox(height: 16),
            _PaymentPanel(order: order),
            const SizedBox(height: 22),
            _ReorderButton(order: order, onReordered: () => _reorder(context)),
          ],
        ],
      ),
    );
  }

  /// Replays the order into the live cart.
  ///
  /// The cart owns its own invariants, so this screen re-dispatches the same
  /// events the cards do — one `CartItemAdded` per serving plus a single delta
  /// for the remainder — instead of touching the state directly.
  void _reorder(BuildContext context) {
    final cart = context.read<CartBloc>();
    for (final item in order.items) {
      cart.add(CartItemAdded(item.meal));
      if (item.quantity > 1) {
        cart.add(CartItemQuantityChanged(item.meal.id, item.quantity - 1));
      }
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          key: const ValueKey('order_details_reorder_snackbar'),
          content: Text(context.l10n.reorderDone),
        ),
      );

    Navigator.of(context).pushNamed(AppRoutes.cart);
  }
}

/// Status, reference number, placed-at and a one-line money summary.
class _ReceiptHeader extends StatelessWidget {
  const _ReceiptHeader({required this.order});

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isActive = order.status == OrderStatus.active;
    final accent = isActive
        ? AppColors.primary
        : theme.colorScheme.onSurface.withValues(alpha: 0.6);

    return AppSurface(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isActive
                    ? Icons.soup_kitchen_rounded
                    : Icons.check_circle_rounded,
                size: 18,
                color: accent,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isActive
                      ? context.l10n.orderPreparing
                      : context.l10n.orderDelivered,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: accent,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Two lines instead of an ellipsis: the reference is the one thing a
          // shopper has to read out to support, so cutting it off defeats the
          // point of printing it. The isolate forces the `sb-…` id to stay a
          // left-to-right run inside an Arabic paragraph, where a bare `#`
          // otherwise reorders to the far end of the digits.
          Text(
            context.l10n.orderNumber('\u2066${order.id}\u2069'),
            key: const ValueKey('order_details_number'),
            maxLines: 2,
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          Text(
            context.l10n.placedOn(context.formatOrderDate(order.placedAt)),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(
                  context.itemCount(order.itemCount),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
                  ),
                ),
              ),
              Text(
                formatPrice(order.total),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Section caption above a block of the receipt.
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 4, bottom: 8, top: 4),
      child: Text(label, style: theme.textTheme.titleMedium),
    );
  }
}

/// One purchased line: artwork, name, unit price × quantity, line total.
///
/// Tapping it opens the meal, which is how a shopper re-orders a single dish
/// rather than the whole basket.
class _OrderLine extends StatelessWidget {
  const _OrderLine({required this.item, required this.onOpenMeal});

  final CartItemEntity item;
  final VoidCallback onOpenMeal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SemanticId(
      id: 'order_line_${item.meal.id}',
      button: true,
      label:
          '${item.meal.name} · ${context.l10n.orderLineQuantity(item.quantity)}',
      child: AppSurface(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        onTap: onOpenMeal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppNetworkImage(
              url: item.meal.thumbnailUrl,
              width: 54,
              height: 54,
              borderRadius: BorderRadius.circular(14),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.meal.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${formatPrice(item.meal.price)} · '
                    '${context.l10n.orderLineQuantity(item.quantity)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              formatPrice(item.lineTotal),
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Subtotal / delivery / service / total, straight off the order snapshot.
class _MoneyBreakdown extends StatelessWidget {
  const _MoneyBreakdown({required this.order});

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    // A waived delivery fee reads as "Free", which is what the cart's own
    // summary panel does — the two must not disagree.
    final freeDelivery = order.deliveryFee <= 0;

    return AppSurface(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        children: [
          _MoneyRow(
            label: context.l10n.subtotal,
            value: formatPrice(order.subtotal),
          ),
          _MoneyRow(
            label: context.l10n.deliveryFee,
            value: freeDelivery
                ? context.l10n.free
                : formatPrice(order.deliveryFee),
            highlightValue: freeDelivery,
          ),
          _MoneyRow(
            label: context.l10n.serviceFee,
            value: formatPrice(order.serviceFee),
          ),
          const Divider(height: 24),
          _MoneyRow(
            label: context.l10n.total,
            value: formatPrice(order.total),
            emphasise: true,
          ),
        ],
      ),
    );
  }
}

class _MoneyRow extends StatelessWidget {
  const _MoneyRow({
    required this.label,
    required this.value,
    this.emphasise = false,
    this.highlightValue = false,
  });

  final String label;
  final String value;
  final bool emphasise;

  /// Tints a zeroed fee green instead of showing `$0.00`.
  final bool highlightValue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: emphasise
                  ? theme.textTheme.titleMedium
                  : theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(
                        alpha: 0.72,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            value,
            style:
                (emphasise
                        ? theme.textTheme.titleMedium
                        : theme.textTheme.bodyMedium)
                    ?.copyWith(
                      color: emphasise || highlightValue
                          ? theme.colorScheme.primary
                          : null,
                      fontWeight: emphasise || highlightValue
                          ? FontWeight.w800
                          : null,
                    ),
          ),
        ],
      ),
    );
  }
}

/// Which strategy paid for this order, rendered through the strategy itself.
class _PaymentPanel extends StatelessWidget {
  const _PaymentPanel({required this.order});

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // The *strategy* owns its receipt wording (Strategy pattern) — this widget
    // only supplies the already-localised label it resolves to.
    final receipt = order.payment.receiptLine(
      context.trKey(order.payment.labelKey),
    );

    return AppSurface(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              order.payment.type == PaymentType.cash
                  ? Icons.payments_rounded
                  : Icons.credit_card_rounded,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.paymentMethod,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  receipt,
                  key: const ValueKey('order_details_payment'),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 2),
                Text(
                  context.trKey(order.payment.descriptionKey),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Pushes every line of the order back into the cart in one tap.
class _ReorderButton extends StatelessWidget {
  const _ReorderButton({required this.order, required this.onReordered});

  final OrderEntity order;
  final VoidCallback onReordered;

  @override
  Widget build(BuildContext context) {
    return SemanticId(
      id: 'reorder_button',
      button: true,
      label: context.l10n.reorder,
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: FilledButton.icon(
          key: const ValueKey('reorder_button'),
          onPressed: onReordered,
          icon: const Icon(Icons.refresh_rounded),
          label: Text(
            context.l10n.reorder,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
