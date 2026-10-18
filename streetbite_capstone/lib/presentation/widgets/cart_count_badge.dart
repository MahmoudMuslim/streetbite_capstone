import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_state.dart';
import '../extensions/cart_quantity.dart';
import '../extensions/l10n_extension.dart';

/// How many servings of one meal are in the cart, printed on the product
/// artwork so the answer is visible before the shopper looks at the button.
///
/// Placed by the owning card (`PositionedDirectional(top: 10, start: 10)`) —
/// the badge only knows how to draw itself, never where it lives. It watches
/// [CartBloc] on its own, so every card on screen updates the moment a line
/// changes anywhere in the app; no screen threads a quantity prop through.
class CartCountBadge extends StatelessWidget {
  const CartCountBadge({super.key, required this.mealId});

  final String mealId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      buildWhen: (previous, current) =>
          previous.quantityOf(mealId) != current.quantityOf(mealId),
      builder: (context, state) {
        final count = state.quantityOf(mealId);
        // Out of the cart: the pill must not leave a gap over the image.
        if (count == 0) return const SizedBox.shrink();

        return Semantics(
          label: context.l10n.inCartCount(count),
          child: _CountPill(
            key: ValueKey('cart_count_badge_$mealId'),
            count: count,
          ),
        );
      },
    );
  }
}

/// The pill itself.
class _CountPill extends StatelessWidget {
  const _CountPill({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      constraints: const BoxConstraints(minWidth: 26),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(14),
        // The white ring is what separates the pill from arbitrary food
        // photography, so it carries the whole job on its own: a shadow here
        // makes Impeller reject the layer under the glass themes
        // (`Contents::SetInheritedOpacity`) and the card stops painting.
        border: Border.all(color: Colors.white.withValues(alpha: 0.75)),
      ),
      child: Text(
        '$count',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w800,
          height: 1.2,
        ),
      ),
    );
  }
}
