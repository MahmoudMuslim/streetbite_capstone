import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_state.dart';

/// Green circular badge showing how many servings are in the cart.
///
/// Wrapping the AppBar cart icon in this widget means the badge updates
/// reactively **everywhere** the icon appears, with no manual refresh call in
/// any screen.
class CartBadge extends StatelessWidget {
  const CartBadge({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      buildWhen: (previous, current) => _countOf(previous) != _countOf(current),
      builder: (context, state) {
        final count = _countOf(state);
        return Stack(
          clipBehavior: Clip.none,
          children: [
            child,
            if (count > 0)
              PositionedDirectional(
                end: -6,
                top: -4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  constraints: const BoxConstraints(minWidth: 18),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$count',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  static int _countOf(CartState state) =>
      state is CartUpdated ? state.itemCount : 0;
}
