import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// The aurora gradient that Liquid Glass surfaces refract against.
///
/// Extracted from [GlassBackdrop] because two hosts need it: the app-wide layer
/// behind the `Navigator`, and the `background` slot of a `GlassScaffold`, which
/// paints its own layer and therefore cannot see through to the app-wide one.
///
/// The palette follows the active brightness, because glass ships in a light
/// and a dark variant and frosted panels need a canvas of matching luminance to
/// read against.
class GlassAurora extends StatelessWidget {
  const GlassAurora({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final canvasTop = isDark
        ? AppColors.glassCanvasTop
        : AppColors.glassCanvasTopLight;
    final canvasBottom = isDark
        ? AppColors.glassCanvasBottom
        : AppColors.glassCanvasBottomLight;
    // The blobs keep their hue in both variants but lose most of their alpha in
    // light mode: a saturated green wash over a pale canvas reads as a stain.
    final green = isDark ? const Color(0x5900C16A) : const Color(0x4000C16A);
    final blue = isDark ? const Color(0x402E6BFF) : const Color(0x332E6BFF);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [canvasTop, canvasBottom],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(-1.1, -0.85),
                  radius: 1.1,
                  colors: [green, green.withValues(alpha: 0)],
                ),
              ),
            ),
          ),
          IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(1.15, 0.35),
                  radius: 1.0,
                  colors: [blue, blue.withValues(alpha: 0)],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
