import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth/auth_cubit.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/orders/orders_cubit.dart';
import '../../extensions/l10n_extension.dart';
import 'home_screen.dart';
import '../orders/orders_screen.dart';
import '../profile/profile_tab_screen.dart';
import '../browse/browse_screen.dart';

/// The bottom-navigation shell from the Figma design
/// (Home / Browse / Orders / Profile).
///
/// An [IndexedStack] is used rather than rebuilding each tab on switch: the Home
/// feed keeps its scroll position and its `PageView` index, and returning from
/// the Cart does not re-trigger a network fetch. That matters on a phone where
/// users bounce between tabs dozens of times per session.
class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key, this.initialIndex = 0});

  /// Tab the shell opens on. The order-confirmation screen rebuilds the shell
  /// on the Orders tab via this, because its button says "View my orders" —
  /// landing on Home made the button look broken.
  final int initialIndex;

  static const int ordersTabIndex = 2;

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  late int _index = widget.initialIndex;

  /// Tabs are built lazily and kept alive so their state survives.
  final _built = <int, Widget>{};

  @override
  void initState() {
    super.initState();
    // Warm the favourites + orders caches once, so the Profile tab and the
    // Orders tab render instantly on first tap.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<AuthCubit>().state;
      if (state is AuthAuthenticated) {
        context.read<OrdersCubit>().load(state.user.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          _tab(0, const HomeScreen()),
          _tab(1, const BrowseScreen()),
          _tab(2, const OrdersScreen()),
          _tab(3, const ProfileTabScreen()),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).navigationBarTheme.backgroundColor,
          border: Border(
            top: BorderSide(color: Theme.of(context).dividerColor),
          ),
        ),
        child: NavigationBar(
          key: const ValueKey('main_bottom_navigation'),
          backgroundColor: Colors.transparent,
          selectedIndex: _index,
          onDestinationSelected: (index) => setState(() => _index = index),
          destinations: [
            NavigationDestination(
              key: const ValueKey('nav_home'),
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home_rounded),
              label: context.l10n.homeTitle,
            ),
            NavigationDestination(
              key: const ValueKey('nav_browse'),
              icon: const Icon(Icons.search_rounded),
              selectedIcon: const Icon(Icons.travel_explore_rounded),
              label: context.l10n.browseTitle,
            ),
            NavigationDestination(
              key: const ValueKey('nav_orders'),
              icon: const Icon(Icons.receipt_long_outlined),
              selectedIcon: const Icon(Icons.receipt_long_rounded),
              label: context.l10n.ordersTitle,
            ),
            NavigationDestination(
              key: const ValueKey('nav_profile'),
              icon: const Icon(Icons.person_outline_rounded),
              selectedIcon: const Icon(Icons.person_rounded),
              label: context.l10n.profileTitle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _tab(int index, Widget screen) =>
      _built.putIfAbsent(index, () => screen);
}
