import 'package:flutter/material.dart';

import 'shimmer_box.dart';
import 'shimmer_scope.dart';

/// Loading placeholder for the horizontal favourites strip on Profile.
class FavouritesSkeleton extends StatelessWidget {
  const FavouritesSkeleton({super.key, this.itemCount = 3});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ShimmerScope(
      child: Row(
        children: [
          for (var i = 0; i < itemCount; i++)
            Padding(
              padding: EdgeInsetsDirectional.only(
                end: i == itemCount - 1 ? 0 : 12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  ShimmerBox(width: 110, height: 112, borderRadius: 16),
                  SizedBox(height: 8),
                  ShimmerBox(width: 74, height: 10, borderRadius: 5),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
