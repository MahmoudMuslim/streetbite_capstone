import 'package:flutter/material.dart';

/// A single opaque placeholder shape inside a [ShimmerScope].
///
/// The colour is irrelevant — `shimmer` paints its gradient through the child's
/// alpha — but it must be fully opaque or the sweep has nothing to mask.
class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 10,
  });

  /// Circular placeholder (avatars, icon wells).
  const ShimmerBox.circle({super.key, required double size})
    : width = size,
      height = size,
      borderRadius = 999;

  final double? width;
  final double? height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
