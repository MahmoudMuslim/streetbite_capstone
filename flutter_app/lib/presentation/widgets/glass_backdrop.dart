import 'package:flutter/material.dart';

import 'glass_aurora.dart';

/// Paints [GlassAurora] behind the whole `Navigator` in Liquid Glass mode.
///
/// Glass refracts whatever sits underneath it, and the glass theme sets
/// `scaffoldBackgroundColor` to transparent — so without this layer every route
/// would float over flat black and the frost would have nothing to show.
/// Installed once from `MaterialApp.builder`, which means pushed routes keep the
/// same backdrop without each screen knowing the theme exists.
class GlassBackdrop extends StatelessWidget {
  const GlassBackdrop({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(fit: StackFit.expand, children: [const GlassAurora(), child]);
  }
}
