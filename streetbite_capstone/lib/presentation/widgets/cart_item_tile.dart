import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/string_helpers.dart';
import '../../../domain/entities/cart_item_entity.dart';
import 'app_network_image.dart';
import 'app_surface.dart';

/// One line of the cart: image, name, price, quantity stepper and a remove
/// button.
///
/// Reused by the Cart screen and the order-confirmation summary, which is why
/// the quantity controls are an optional callback pair rather than being
/// hard-wired to `CartBloc`.
class CartItemTile extends StatelessWidget {
  const CartItemTile({
    super.key,
    required this.item,
    this.onIncrement,
    this.onDecrement,
    this.onRemove,
    this.showQuantityControls = true,
  });

  final CartItemEntity item;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final VoidCallback? onRemove;

  /// `false` for read-only summaries (order history, confirmation screen).
  final bool showQuantityControls;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppSurface(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppNetworkImage(
            key: ValueKey('cart_item_image_${item.meal.id}'),
            url: item.meal.thumbnailUrl,
            width: 74,
            height: 74,
            borderRadius: BorderRadius.circular(16),
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
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  formatPrice(item.meal.price),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.mutedCaption,
                  ),
                ),
                const SizedBox(height: 8),
                if (showQuantityControls)
                  _QuantityStepper(
                    mealId: item.meal.id,
                    quantity: item.quantity,
                    onIncrement: onIncrement,
                    onDecrement: onDecrement,
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatPrice(item.lineTotal),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              if (onRemove != null) ...[
                const SizedBox(height: 12),
                InkWell(
                  key: ValueKey('cart_remove_button_${item.meal.id}'),
                  onTap: onRemove,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                      Icons.delete_outline_rounded,
                      size: 22,
                      color: theme.colorScheme.error,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// − / quantity / + control used by [CartItemTile].
///
/// Deliberately the same tinted pill as the `+ count -` control on the product
/// cards: one shape means "change how many", whether you are on a card or in
/// the cart list.
class _QuantityStepper extends StatelessWidget {
  const _QuantityStepper({
    required this.mealId,
    required this.quantity,
    this.onIncrement,
    this.onDecrement,
  });

  final String mealId;
  final int quantity;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.45),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // `+ count -`, the same reading order as the card and the details
          // CTA: one control, one shape, wherever the shopper meets it.
          _StepButton(
            icon: Icons.add_rounded,
            onTap: onIncrement,
            buttonKey: ValueKey('cart_increment_$mealId'),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 22),
            child: Text(
              '$quantity',
              key: ValueKey('cart_quantity_text_$mealId'),
              textAlign: TextAlign.center,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          _StepButton(
            icon: Icons.remove_rounded,
            onTap: onDecrement,
            buttonKey: ValueKey('cart_decrement_$mealId'),
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.onTap,
    required this.buttonKey,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final Key buttonKey;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        key: buttonKey,
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 30,
          height: 30,
          child: Icon(
            icon,
            size: 17,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
