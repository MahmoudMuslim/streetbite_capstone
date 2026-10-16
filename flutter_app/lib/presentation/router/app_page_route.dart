import 'package:flutter/material.dart';

/// Route used for every navigation in the app.
///
/// A short fade combined with a small upward slide makes the whole app feel
/// composed instead of "screens snapping into place", and because it is a
/// `PageRoute` the meal-card Hero flights still work.
class AppPageRoute<T> extends PageRouteBuilder<T> {
  AppPageRoute({required WidgetBuilder builder, super.settings})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) =>
            builder(context),
        transitionDuration: _duration,
        reverseTransitionDuration: _duration,
      );

  static const Duration _duration = Duration(milliseconds: 320);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
    );

    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.035),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }
}
