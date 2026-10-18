import 'package:flutter/material.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../extensions/l10n_extension.dart';
import '../../widgets/success_burst.dart';
import '../home/main_shell_screen.dart';

/// Shown after a successful checkout.
///
/// The screen is stateful only because the success artwork animates: the copy
/// and the button stagger in behind it, which is what makes the moment read as
/// "your order landed" rather than as another static page.
class OrderConfirmationScreen extends StatefulWidget {
  const OrderConfirmationScreen({super.key});

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBody: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.radius),
          child: Column(
            children: [
              const Spacer(),
              SuccessBurst(
                controller: _controller,
                child: Container(
                  width: 132,
                  height: 132,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle_rounded,
                    size: 78,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              _Staggered(
                controller: _controller,
                start: 0.35,
                child: Text(
                  context.l10n.orderPlacedTitle,
                  style: theme.textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 12),
              _Staggered(
                controller: _controller,
                start: 0.5,
                child: Text(
                  context.l10n.orderPlacedMessage,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(),
              _Staggered(
                controller: _controller,
                start: 0.65,
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    key: const ValueKey('view_orders_button'),
                    // Rebuild the shell on the Orders tab: every route is
                    // popped, so the confirmation screen cannot be returned to
                    // and the cart badge starts from the cleared cart.
                    onPressed: () => Navigator.of(context)
                        .pushNamedAndRemoveUntil(
                          AppRoutes.home,
                          (route) => false,
                          arguments: [MainShellScreen.ordersTabIndex],
                        ),
                    child: Text(context.l10n.viewMyOrders),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Fades and lifts [child] in during the tail of [controller].
class _Staggered extends StatelessWidget {
  const _Staggered({
    required this.controller,
    required this.start,
    required this.child,
  });

  final AnimationController controller;

  /// Fraction of the controller's timeline at which this element begins.
  final double start;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final animation = CurvedAnimation(
      parent: controller,
      curve: Interval(start, 1, curve: Curves.easeOutCubic),
    );

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.06),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }
}
