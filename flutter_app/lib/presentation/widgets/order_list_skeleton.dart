import 'package:flutter/material.dart';

import 'shimmer_box.dart';
import 'shimmer_scope.dart';

/// Loading placeholder for an order history list.
///
/// Shared by the Orders tab and the Profile order-history section so both show
/// the same tile silhouette while Firestore answers.
class OrderListSkeleton extends StatelessWidget {
  const OrderListSkeleton({super.key, this.itemCount = 3});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ShimmerScope(
      child: Column(
        children: [
          for (var i = 0; i < itemCount; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  const ShimmerBox(width: 56, height: 56, borderRadius: 16),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        ShimmerBox(width: 120, height: 12, borderRadius: 6),
                        SizedBox(height: 10),
                        ShimmerBox(height: 9, borderRadius: 5),
                        SizedBox(height: 8),
                        ShimmerBox(width: 70, height: 9, borderRadius: 5),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  const ShimmerBox(width: 62, height: 24, borderRadius: 12),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
