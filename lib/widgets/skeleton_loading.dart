import 'package:flutter/material.dart';
import 'shimmer_loading.dart';

class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerLoading(height: 24, width: 150),
            SizedBox(height: 16),
            ShimmerLoading(height: 16, width: 200),
            SizedBox(height: 8),
            ShimmerLoading(height: 16, width: 180),
          ],
        ),
      ),
    );
  }
} 