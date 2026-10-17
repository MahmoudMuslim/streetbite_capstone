import 'package:flutter/widgets.dart';

/// Responsive layout helpers built on top of [MediaQuery].
///
/// StreetBite must look right on a 360dp phone and on a 600dp+ tablet, so all
/// screen code asks this helper instead of hard-coding grid columns / paddings.
/// Each getter documents the exact [MediaQuery] breakpoint it reacts to.
class Responsive {
  const Responsive._();

  /// Layouts below this width are treated as compact (phone).
  static const double compactBreakpoint = 600;

  /// Layouts at or above this width are treated as expanded (tablet).
  static const double expandedBreakpoint = 900;

  /// `true` when the shortest side is a phone-sized screen.
  static bool isCompact(BuildContext context) =>
      MediaQuery.sizeOf(context).width < compactBreakpoint;

  /// Number of columns for the meals [GridView].
  /// * phone  -> 2 columns (as designed in Figma)
  /// * tablet -> 3 columns
  /// * large  -> 4 columns
  static int mealGridColumns(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= expandedBreakpoint) return 4;
    if (width >= compactBreakpoint) return 3;
    return 2;
  }

  /// Horizontal page padding that grows on wider screens.
  static double horizontalPadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= expandedBreakpoint) return 32;
    if (width >= compactBreakpoint) return 24;
    return 20;
  }

  /// Bottom scroll padding that lets the last row of a tab clear the app's
  /// bottom bar while the body still paints *behind* it.
  ///
  /// The shell publishes the bar's clearance as `MediaQuery.padding.bottom`:
  /// Material does it on its own once `Scaffold.extendBody` is on, the glass
  /// shell does it explicitly. Screens therefore never hard-code a bar height,
  /// and a route outside the shell falls back to the plain system inset.
  static double bottomBarClearance(BuildContext context) =>
      MediaQuery.paddingOf(context).bottom;

  /// Constrains the readable width on tablets so text lines never stretch.
  static Widget constrainWidth(BuildContext context, {required Widget child}) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: child,
      ),
    );
  }
}
