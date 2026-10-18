import 'package:flutter/material.dart';

import '../../core/utils/responsive.dart';

/// Constrained, scrollable page body used by every full-page form screen.
///
/// Applies the responsive max width and the shared horizontal padding in one
/// place, so Login, Sign Up and Profile cannot drift apart visually and every
/// screen is usable on a 360dp phone and a 900dp tablet.
class AppPageBody extends StatelessWidget {
  const AppPageBody({super.key, required this.children, this.padding});

  final List<Widget> children;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final base =
        padding ??
        EdgeInsets.symmetric(
          horizontal: Responsive.horizontalPadding(context),
          vertical: 16,
        );

    return SafeArea(
      child: SingleChildScrollView(
        padding: base,
        child: Responsive.constrainWidth(
          context,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ),
    );
  }
}
