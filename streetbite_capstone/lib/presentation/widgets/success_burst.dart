import 'package:flutter/material.dart';

/// Pops [child] in with an overshoot and sends two colour-matched ripples out
/// from behind it.
///
/// Kept separate from the confirmation screen so any future "done" moment can
/// reuse the same beat, and so the screen itself stays readable.
class SuccessBurst extends StatelessWidget {
  const SuccessBurst({
    super.key,
    required this.controller,
    required this.child,
  });

  final AnimationController controller;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final t = CurvedAnimation(
          parent: controller,
          curve: Curves.easeOutCubic,
        ).value;

        return SizedBox(
          width: 216,
          height: 216,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _Ripple(color: color, progress: t, delay: 0),
              _Ripple(color: color, progress: t, delay: 0.18),
              Transform.scale(
                scale: Curves.easeOutBack.transform(t.clamp(0.0, 1.0)),
                child: child,
              ),
            ],
          ),
        );
      },
    );
  }
}

/// One expanding, fading ring.
class _Ripple extends StatelessWidget {
  const _Ripple({
    required this.color,
    required this.progress,
    required this.delay,
  });

  final Color color;

  /// 0..1 across the whole burst.
  final double progress;

  /// Fraction of the timeline this ring waits before starting.
  final double delay;

  @override
  Widget build(BuildContext context) {
    final local = ((progress - delay) / (1 - delay)).clamp(0.0, 1.0);
    if (local <= 0) return const SizedBox.shrink();

    final size = 132 + (76 * local);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: color.withValues(alpha: 0.34 * (1 - local)),
          width: 2,
        ),
      ),
    );
  }
}
