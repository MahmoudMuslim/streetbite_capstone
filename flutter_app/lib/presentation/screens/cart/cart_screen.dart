import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/cart_item_entity.dart';
import '../../../domain/entities/payment.dart';
import '../../../domain/usecases/calculate_order_totals.dart';
import '../../blocs/auth/auth_cubit.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/cart/cart_event.dart';
import '../../blocs/cart/cart_state.dart';
import '../../extensions/l10n_extension.dart';
import '../../widgets/cart_item_tile.dart';
import '../../widgets/empty_state_view.dart';
import '../../widgets/order_summary_card.dart';
import '../../widgets/payment_method_selector.dart';

/// Cart + checkout screen.
///
/// Uses three Bloc widgets for three distinct jobs, which is the textbook
/// reason to reach for Bloc instead of `setState`:
/// * `BlocBuilder`  -> render the item list and the totals.
/// * `BlocListener` -> SnackBars when the cart becomes empty or an add fails.
/// * the `CartBloc` itself owns the order entity handed to Firestore.
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  /// The checkout strategy chosen on this screen.
  ///
  /// Held as a [PaymentMethod] abstraction, never as an enum, so the screen
  /// compiles unchanged when a third strategy is added (Open/closed).
  PaymentMethod _payment = const CashPayment();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.cart)),
      body: BlocListener<CartBloc, CartState>(
        listener: (context, state) {
          // "Show a SnackBar when the cart becomes empty" — requirement 4.
          if (state is CartUpdated && state.justEmptied) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  key: const ValueKey('cart_emptied_snackbar'),
                  content: Text(context.l10n.yourCartCleared),
                ),
              );
          }
          if (state is CartFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  key: const ValueKey('cart_failure_snackbar'),
                  content: Text(context.trKey(state.messageKey)),
                ),
              );
          }
          if (state is CartOrderPlaced) {
            context.read<CartBloc>().add(const CartCleared());
            Navigator.of(context).pushNamedAndRemoveUntil(
              AppRoutes.orderConfirmation,
              (route) => false,
            );
          }
        },
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            final items = switch (state) {
              CartUpdated(:final items) => items,
              CartFailure(:final items) => items,
              _ => const <CartItemEntity>[],
            };

            if (items.isEmpty) {
              return EmptyStateView(
                titleKey: 'cartEmpty',
                bodyKey: 'cartEmptyBody',
                icon: Icons.shopping_bag_outlined,
                actionLabelKey: 'browseMenu',
                onAction: () =>
                    Navigator.of(context).popUntil((route) => route.isFirst),
              );
            }

            return _buildCheckout(context, state, items);
          },
        ),
      ),
    );
  }

  Widget _buildCheckout(
    BuildContext context,
    CartState state,
    List<CartItemEntity> items,
  ) {
    final totals = switch (state) {
      CartUpdated(:final totals) => totals,
      CartFailure(:final totals) => totals,
      _ => const OrderTotals(
        subtotal: 0,
        deliveryFee: 0,
        serviceFee: 0,
        total: 0,
      ),
    };

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            key: const ValueKey('cart_items_list'),
            padding: const EdgeInsets.fromLTRB(
              AppTheme.radius,
              8,
              AppTheme.radius,
              8,
            ),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) => CartItemTile(
              item: items[index],
              onIncrement: () => context.read<CartBloc>().add(
                CartItemQuantityChanged(items[index].meal.id, 1),
              ),
              onDecrement: () => context.read<CartBloc>().add(
                CartItemQuantityChanged(items[index].meal.id, -1),
              ),
              onRemove: () => context.read<CartBloc>().add(
                CartItemRemoved(items[index].meal.id),
              ),
            ),
          ),
        ),
        OrderSummaryCard(
          totals: totals,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.l10n.paymentMethod,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              PaymentMethodSelector(
                selected: _payment,
                onChanged: (method) => setState(() => _payment = method),
              ),
              const SizedBox(height: 20),
              FilledButton(
                key: const ValueKey('place_order_button'),
                onPressed: () => _placeOrder(context),
                child: Text(context.l10n.placeOrder),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _placeOrder(BuildContext context) async {
    final authState = context.read<AuthCubit>().state;
    if (authState is! AuthAuthenticated) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(context.l10n.authSessionExpired)),
        );
      return;
    }
    await context.read<CartBloc>().checkout(
      user: authState.user,
      payment: _payment,
    );
  }
}
