import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// The StreetBite mark: a rounded green tile with a fork-and-plate glyph.
///
/// Drawn with [CustomPaint] instead of shipping a PNG so it stays crisp at
/// every density and needs no asset entry — one less thing to break in a
/// release build.
class StreetBiteLogo extends StatelessWidget {
  const StreetBiteLogo({super.key, this.size = 96});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: size * 0.18,
            offset: Offset(0, size * 0.06),
          ),
        ],
      ),
      child: CustomPaint(
        painter: _LogoPainter(),
        size: Size.square(size * 0.62),
      ),
    );
  }
}

/// Paints the abstract "bowl + cutlery" mark used across the app.
class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.11
      ..strokeCap = StrokeCap.round;

    final bowl = Rect.fromLTWH(
      size.width * 0.06,
      size.height * 0.52,
      size.width * 0.88,
      size.height * 0.34,
    );
    canvas.drawArc(bowl, 0, 3.14159, false, paint);

    // Three steam strokes above the bowl.
    for (var i = 0; i < 3; i++) {
      final x = size.width * (0.28 + i * 0.22);
      canvas.drawLine(
        Offset(x, size.height * 0.40),
        Offset(x, size.height * 0.12),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _LogoPainter oldDelegate) => false;
}
