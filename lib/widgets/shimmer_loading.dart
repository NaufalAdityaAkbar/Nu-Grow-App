import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final Color baseColor;
  final Color highlightColor;
  final Duration duration;

  const ShimmerLoading({
    this.width = double.infinity,
    required this.height,
    this.borderRadius = 8,
    this.baseColor = const Color(0xFFEEEEEE),
    this.highlightColor = const Color(0xFFFAFAFA),
    this.duration = const Duration(milliseconds: 1500),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Shimmer.fromColors(
      baseColor: isDarkMode ? Colors.grey[800]! : baseColor,
      highlightColor: isDarkMode ? Colors.grey[700]! : highlightColor,
      period: duration,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class ShimmerList extends StatelessWidget {
  const ShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ShimmerLoading(
          height: 24,
          width: 200,
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            return const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerLoading(
                    height: 16,
                    width: 150,
                  ),
                  SizedBox(height: 8),
                  ShimmerLoading(
                    height: 12,
                    width: 200,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
} 