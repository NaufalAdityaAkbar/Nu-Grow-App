import 'package:flutter/material.dart';
import 'shimmer_loading.dart';

class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerLoading(height: 24, width: 150),
            const SizedBox(height: 16),
            ShimmerLoading(height: 16, width: 200),
            const SizedBox(height: 8),
            ShimmerLoading(height: 16, width: 180),
          ],
        ),
      ),
    );
  }
} 