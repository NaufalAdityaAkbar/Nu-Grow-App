import 'package:flutter/material.dart';
import 'dart:ui';

class ParallaxBackground extends StatelessWidget {
  final ScrollController scrollController;
  final List<Color> colors;
  final double intensity;

  const ParallaxBackground({
    required this.scrollController,
    required this.colors,
    this.intensity = 0.5,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: scrollController,
      builder: (context, child) {
        final offset = scrollController.hasClients 
            ? (scrollController.offset * intensity).clamp(0.0, double.infinity)
            : 0.0;
        
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: colors,
                  stops: [0, 1],
                  transform: GradientRotation(offset / 1000),
                ),
              ),
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 1.5,
                  sigmaY: 1.5,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.topCenter,
                      radius: 1.5,
                      colors: [Colors.white, Colors.white.withOpacity(0)],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
} 