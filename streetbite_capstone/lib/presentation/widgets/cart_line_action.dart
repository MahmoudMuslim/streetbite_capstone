import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/meal_entity.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_event.dart';
import '../blocs/cart/cart_state.dart';
import '../extensions/cart_quantity.dart';
import '../extensions/l10n_extension.dart';
import 'semantic_id.dart';

/// The cart control on a product card.
///
/// One affordance per state: a single **+** while the meal is not in the cart,
/// then a `+ count -` stepper the moment it is, so the card shows both *how
/// many* and the way to change it without sending the shopper to the Cart
/// screen. It watches [CartBloc] for this one meal and rebuilds only when that
/// meal's quantity changes, which is what lets every card on the Home grid, in
/// the Hot Offers strip and in search results stay in sync with each other.
class CartLineAction extends StatelessWidget {
  const CartLineAction({super.key, required this.meal, this.large = false});

  final MealEntity meal;

  /// Card density is the default; `large` is the Meal-details CTA, where the
  /// control replaces a full-width "Add to cart" button and has to carry the
  /// same visual weight.
  final bool large;

  void _add(BuildContext context) =>
      context.read<CartBloc>().add(CartItemAdded(meal));

  /// `-1` rather than "remove the line": the bloc drops the line at zero, so a
  /// single decrement of the last serving is the same code path the Cart screen
  /// already uses.
  void _removeOne(BuildContext context) =>
      context.read<CartBloc>().add(CartItemQuantityChanged(meal.id, -1));

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      buildWhen: (previous, current) =>
          previous.quantityOf(meal.id) != current.quantityOf(meal.id),
      builder: (context, state) {
        final quantity = state.quantityOf(meal.id);

        return quantity == 0
            ? _AddButton(
                meal: meal,
                large: large,
                onPressed: () => _add(context),
              )
            : _QuantityStepper(
                meal: meal,
                quantity: quantity,
                large: large,
                onAdd: () => _add(context),
                onRemove: () => _removeOne(context),
              );
      },
    );
  }
}

/// The add affordance shown while the meal is still out of the cart: the small
/// "+" square on a card, the full-width CTA on the details screen.
class _AddButton extends StatelessWidget {
  const _AddButton({
    required this.meal,
    required this.large,
    required this.onPressed,
  });

  final MealEntity meal;
  final bool large;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = '${context.l10n.addToCart} ${meal.name}';

    if (large) {
      return Semantics(
        button: true,
        label: label,
        child: FilledButton.icon(
          onPressed: onPressed,
          icon: const Icon(Icons.add_shopping_cart_rounded),
          label: Text(
            context.l10n.addToCart,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }

    return SemanticId(
      id: 'add_to_cart_button_${meal.id}',
      label: label,
      button: true,
      child: Material(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(13),
        elevation: 0,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(13),
          child: Container(
            // Same 34dp height as the stepper so the row does not jump when
            // the button morphs into `+ count -`.
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.35),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
          ),
        ),
      ),
    );
  }
}

/// `+ count -`: the add button grown around the quantity it owns.
class _QuantityStepper extends StatelessWidget {
  const _QuantityStepper({
    required this.meal,
    required this.quantity,
    required this.large,
    required this.onAdd,
    required this.onRemove,
  });

  final MealEntity meal;
  final int quantity;
  final bool large;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ink = large ? Colors.white : theme.colorScheme.primary;

    final count = SemanticId(
      id: 'cart_line_quantity_${meal.id}',
      label: context.l10n.inCartCount(quantity),
      child: Text(
        '$quantity',
        key: ValueKey('cart_line_quantity_text_${meal.id}'),
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style:
            (large ? theme.textTheme.titleMedium : theme.textTheme.titleSmall)
                ?.copyWith(
                  color: large ? Colors.white : null,
                  fontWeight: FontWeight.w800,
                ),
      ),
    );

    return Container(
      // Compact keeps the pill under ~86dp so the price on a two-column card
      // still has room; the stepper is the widest thing in the row.
      height: large ? 48 : 34,
      width: large ? double.infinity : null,
      padding: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: large
            ? theme.colorScheme.primary
            : theme.colorScheme.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(large ? 24 : 17),
        border: large
            ? null
            : Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.45),
              ),
      ),
      child: Row(
        // The CTA stretches across the sheet; the card pill stays as narrow as
        // its three parts, so the price keeps the rest of the row.
        mainAxisSize: large ? MainAxisSize.max : MainAxisSize.min,
        children: [
          _StepButton(
            icon: Icons.add_rounded,
            onTap: onAdd,
            ink: ink,
            large: large,
            semanticId: 'cart_increase_button_${meal.id}',
            label: context.l10n.increaseQuantity,
          ),
          if (large)
            Expanded(child: count)
          else
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 22),
              child: count,
            ),
          _StepButton(
            icon: Icons.remove_rounded,
            onTap: onRemove,
            ink: ink,
            large: large,
            semanticId: 'cart_decrease_button_${meal.id}',
            label: context.l10n.decreaseQuantity,
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
    required this.ink,
    required this.large,
    required this.semanticId,
    required this.label,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color ink;
  final bool large;
  final String semanticId;
  final String label;

  @override
  Widget build(BuildContext context) {
    final side = large ? 44.0 : 30.0;

    return SemanticId(
      id: semanticId,
      label: label,
      button: true,
      child: Material(
        color: Colors.transparent,
        // Shaped but *not* clipped: the splash already follows the circle via
        // `customBorder`, and clipping a transparent Material inside a glass
        // card is the combination Impeller refuses to composite.
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: side,
            height: side,
            child: Icon(icon, size: large ? 22 : 17, color: ink),
          ),
        ),
      ),
    );
  }
}
