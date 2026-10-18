import 'package:flutter/material.dart';

import '../../core/utils/responsive.dart';
import 'shimmer_box.dart';
import 'shimmer_scope.dart';

/// Loading placeholder that mirrors the real Home feed, section for section.
///
/// Shape-matched on purpose: a spinner tells the user nothing about what is
/// coming, while a skeleton of the actual layout keeps the scroll position and
/// the eye where they will land once the meals arrive — no jarring reflow.
class HomeFeedSkeleton extends StatelessWidget {
  const HomeFeedSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final horizontal = Responsive.horizontalPadding(context);

    return ShimmerScope(
      child: SingleChildScrollView(
        // The skeleton is not scrollable: the real feed replaces it wholesale,
        // and letting the user scroll a placeholder invites a "blank screen"
        // report when they land past the end of it.
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(bottom: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontal),
              child: const ShimmerBox(height: 58, borderRadius: 20),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 96,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: horizontal),
                itemCount: 5,
                separatorBuilder: (_, _) => const SizedBox(width: 14),
                itemBuilder: (_, _) => Column(
                  children: const [
                    ShimmerBox.circle(size: 64),
                    SizedBox(height: 10),
                    ShimmerBox(width: 46, height: 9, borderRadius: 5),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontal),
              child: const ShimmerBox(height: 200, borderRadius: 24),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontal),
              child: const ShimmerBox(width: 130, height: 14, borderRadius: 7),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 190,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: horizontal),
                itemCount: 4,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (_, _) =>
                    const ShimmerBox(width: 156, height: 190, borderRadius: 20),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontal),
              child: const ShimmerBox(width: 160, height: 14, borderRadius: 7),
            ),
            const SizedBox(height: 14),
            _grid(context, horizontal),
          ],
        ),
      ),
    );
  }

  Widget _grid(BuildContext context, double horizontal) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal),
      child: GridView.count(
        crossAxisCount: Responsive.mealGridColumns(context),
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 0.78,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          ShimmerBox(borderRadius: 20),
          ShimmerBox(borderRadius: 20),
          ShimmerBox(borderRadius: 20),
          ShimmerBox(borderRadius: 20),
        ],
      ),
    );
  }
}
