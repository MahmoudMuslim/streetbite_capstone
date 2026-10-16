import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../../../core/theme/app_glass_tokens.dart';
import '../../blocs/auth/auth_cubit.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/orders/orders_cubit.dart';
import '../../extensions/l10n_extension.dart';
import '../../widgets/glass_aurora.dart';
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
///
/// Under the Liquid Glass theme the same stack is hosted by a `GlassScaffold`
/// with a real refractive `GlassTabBar`, which is the one place the glass look
/// changes structure rather than just palette — navigation chrome is what the
/// material is designed for.
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
    final body = IndexedStack(
      index: _index,
      children: [
        _tab(0, const HomeScreen()),
        _tab(1, const BrowseScreen()),
        _tab(2, const OrdersScreen()),
        _tab(3, const ProfileTabScreen()),
      ],
    );

    if (AppGlassTokens.enabledOf(context)) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final tabBar = GlassTabBar.bottom(
        tabs: [
          GlassTab(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home_rounded),
            label: context.l10n.homeTitle,
            semanticLabel: context.l10n.homeTitle,
          ),
          GlassTab(
            icon: const Icon(Icons.search_rounded),
            activeIcon: const Icon(Icons.travel_explore_rounded),
            label: context.l10n.browseTitle,
            semanticLabel: context.l10n.browseTitle,
          ),
          GlassTab(
            icon: const Icon(Icons.receipt_long_outlined),
            activeIcon: const Icon(Icons.receipt_long_rounded),
            label: context.l10n.ordersTitle,
            semanticLabel: context.l10n.ordersTitle,
          ),
          GlassTab(
            icon: const Icon(Icons.person_outline_rounded),
            activeIcon: const Icon(Icons.person_rounded),
            label: context.l10n.profileTitle,
            semanticLabel: context.l10n.profileTitle,
          ),
        ],
        selectedIndex: _index,
        onTabSelected: (index) => setState(() => _index = index),
        verticalPadding: 12,
        // Passing `settings` replaces the package's bar preset wholesale, so
        // the tuned values are repeated here with one change: in dark glass
        // the white tint is dropped to a whisper, otherwise the frost over the
        // dark aurora reads as an opaque grey slab instead of clear glass.
        settings: LiquidGlassSettings(
          thickness: 30,
          blur: 3,
          chromaticAberration: 0.3,
          lightIntensity: 0.6,
          refractiveIndex: 1.59,
          saturation: 0.7,
          ambientStrength: 1,
          lightAngle: 0.75 * math.pi,
          glassColor: isDark
              ? const Color(0x14FFFFFF)
              : const Color(0x3DFFFFFF),
        ),
      );

      return GlassScaffold(
        background: const GlassAurora(),
        // `auto` follows the *device* brightness, which can disagree with the
        // in-app theme, so the style is pinned to the active brightness.
        statusBarStyle: isDark
            ? GlassStatusBarStyle.light
            : GlassStatusBarStyle.dark,
        body: Padding(
          // The capsule floats over the body, so reserve its height or the
          // last row of each tab hides behind the frost.
          padding: const EdgeInsets.only(
            bottom: AppGlassTokens.bottomBarClearance,
          ),
          child: body,
        ),
        // GlassScaffold does not wrap its bottomBar in a Material, so the tab
        // labels would otherwise inherit MaterialApp's fallback text style —
        // monospace with a yellow double underline. Supply the app's own base
        // style with the decoration cleared; the bar still layers its per-state
        // color/size/weight on top.
        bottomBar: DefaultTextStyle(
          style:
              Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(decoration: TextDecoration.none) ??
              const TextStyle(decoration: TextDecoration.none),
          child: tabBar,
        ),
      );
    }

    return Scaffold(
      body: body,
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
