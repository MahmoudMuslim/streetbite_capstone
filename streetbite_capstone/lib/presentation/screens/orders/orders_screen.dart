import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/utils/responsive.dart';
import '../../../domain/entities/order_entity.dart';
import '../../extensions/l10n_extension.dart';
import '../../blocs/auth/auth_cubit.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/orders/orders_cubit.dart';
import '../../blocs/orders/orders_state.dart';
import '../../widgets/app_error_view.dart';
import '../../widgets/empty_state_view.dart';
import '../../widgets/order_history_tile.dart';
import '../../widgets/order_list_skeleton.dart';

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

  Future<void> _refresh() async {
    final state = context.read<AuthCubit>().state;
    if (state is AuthAuthenticated) {
      await context.read<OrdersCubit>().refresh(state.user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
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
      // `bottom: false`: the shell publishes the bar's clearance as a bottom
      // inset, and `_OrderList` turns it into scroll padding so the last order
      // still clears the chrome while rows paint behind it.
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<OrdersCubit, OrdersState>(
          builder: (context, state) {
            return switch (state) {
              OrdersInitial() || OrdersLoading() => Responsive.constrainWidth(
                context,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    Responsive.horizontalPadding(context),
                    16,
                    Responsive.horizontalPadding(context),
                    0,
                  ),
                  child: const OrderListSkeleton(itemCount: 4),
                ),
              ),
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
              OrdersLoaded() => _OrderList(orders: state, onRefresh: _refresh),
            };
          },
        ),
      ),
    );
  }
}

class _OrderList extends StatelessWidget {
  const _OrderList({required this.orders, required this.onRefresh});

  final OrdersLoaded orders;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final padding = EdgeInsets.symmetric(
      horizontal: Responsive.horizontalPadding(context),
      vertical: 8,
    ).copyWith(bottom: 8 + Responsive.bottomBarClearance(context));

    // Both blocks share one push helper, so the Orders tab and the Profile
    // history can never drift into two different ways of opening a receipt.
    void openOrder(OrderEntity order) =>
        Navigator.of(context)
            .pushNamed(AppRoutes.orderDetails, arguments: [order]);

    return Responsive.constrainWidth(
      context,
      child: RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          key: const ValueKey('orders_list'),
          padding: padding,
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            if (orders.active.isNotEmpty) ...[
              _BlockTitle(
                label: context.l10n.current,
                count: orders.active.length,
              ),
              ...orders.active.map(
                (order) => OrderHistoryTile(
                  order: order,
                  onTap: () => openOrder(order),
                ),
              ),
            ],
            if (orders.past.isNotEmpty) ...[
              _BlockTitle(
                label: context.l10n.past,
                count: orders.past.length,
                spacing: 20,
              ),
              ...orders.past.map(
                (order) => OrderHistoryTile(
                  order: order,
                  onTap: () => openOrder(order),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _BlockTitle extends StatelessWidget {
  const _BlockTitle({
    required this.label,
    required this.count,
    this.spacing = 8,
  });

  final String label;
  final int count;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(top: spacing, bottom: 8),
      child: Row(
        children: [
          Text(
            label,
            style: theme.textTheme.headlineSmall?.copyWith(fontSize: 20),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$count',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
