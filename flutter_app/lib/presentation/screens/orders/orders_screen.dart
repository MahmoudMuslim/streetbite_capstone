import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/utils/responsive.dart';
import '../../extensions/l10n_extension.dart';
import '../../blocs/auth/auth_cubit.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/orders/orders_cubit.dart';
import '../../blocs/orders/orders_state.dart';
import '../../widgets/app_error_view.dart';
import '../../widgets/app_loading_view.dart';
import '../../widgets/empty_state_view.dart';
import '../../widgets/order_history_tile.dart';

/// "Orders" tab — the two-block layout from the Figma design.
///
/// Re-reads the history every time the tab is shown so an order placed a
/// second ago appears without a manual pull-to-refresh.
class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _refresh());
  }

  void _refresh() {
    final state = context.read<AuthCubit>().state;
    if (state is AuthAuthenticated) {
      context.read<OrdersCubit>().load(state.user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.ordersTitle),
        actions: [
          IconButton(
            key: const ValueKey('orders_refresh_button'),
            onPressed: _refresh,
            icon: const Icon(Icons.refresh_rounded),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<OrdersCubit, OrdersState>(
          builder: (context, state) {
            return switch (state) {
              OrdersInitial() || OrdersLoading() => const AppLoadingView(),
              OrdersError(:final messageKey) => AppErrorView(
                messageKey: messageKey,
                icon: Icons.receipt_long_rounded,
                onRetry: _refresh,
              ),
              OrdersLoaded(:final orders) when orders.isEmpty => EmptyStateView(
                titleKey: 'orderHistoryEmpty',
                bodyKey: 'orderHistoryEmptyBody',
                icon: Icons.receipt_long_outlined,
                actionLabelKey: 'browseMenu',
                onAction: () =>
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(AppRoutes.home, (_) => false),
              ),
              OrdersLoaded() => _OrderList(orders: state),
            };
          },
        ),
      ),
    );
  }
}

class _OrderList extends StatelessWidget {
  const _OrderList({required this.orders});

  final OrdersLoaded orders;

  @override
  Widget build(BuildContext context) {
    final padding = EdgeInsets.symmetric(
      horizontal: Responsive.horizontalPadding(context),
      vertical: 8,
    );

    return Responsive.constrainWidth(
      context,
      child: ListView(
        key: const ValueKey('orders_list'),
        padding: padding,
        children: [
          if (orders.active.isNotEmpty) ...[
            _BlockTitle(label: context.l10n.current),
            ...orders.active.map((order) => OrderHistoryTile(order: order)),
          ],
          if (orders.past.isNotEmpty) ...[
            _BlockTitle(label: context.l10n.past, spacing: 20),
            ...orders.past.map((order) => OrderHistoryTile(order: order)),
          ],
        ],
      ),
    );
  }
}

class _BlockTitle extends StatelessWidget {
  const _BlockTitle({required this.label, this.spacing = 8});

  final String label;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: spacing, bottom: 4),
      child: Text(
        label,
        style: Theme.of(context).textTheme.headlineSmall
            ?.copyWith(fontSize: 20),
      ),
    );
  }
}
