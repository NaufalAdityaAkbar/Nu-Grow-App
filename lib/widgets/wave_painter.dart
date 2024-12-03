import 'package:flutter/material.dart';
import 'dart:math';

class WavePainter extends CustomPainter {
  final Color color;
  final double amplitude;
  final double phase;
  final double frequency;
  final bool reverse;

  WavePainter({
    required this.color,
    this.amplitude = 20.0,
    this.phase = 0.0,
    this.frequency = 1.5,
    this.reverse = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    final path = Path();
    final width = size.width;
    final height = size.height;
    final midHeight = height * 0.8;

    path.moveTo(0, midHeight);

    for (double i = 0; i <= width; i++) {
      final y = sin((i / width * 2 * pi * frequency) + phase) * amplitude;
      path.lineTo(i, midHeight + (reverse ? -y : y));
    }

    path.lineTo(width, height);
    path.lineTo(0, height);
    path.close();

    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        color.withOpacity(0.2),
        color.withOpacity(0.05),
      ],
    ).createShader(Rect.fromLTWH(0, 0, width, height));

    paint.shader = gradient;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) =>
      color != oldDelegate.color ||
      amplitude != oldDelegate.amplitude ||
      phase != oldDelegate.phase ||
      frequency != oldDelegate.frequency ||
      reverse != oldDelegate.reverse;
} 