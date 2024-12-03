import 'package:flutter/material.dart';

class FadeScaleRoute extends PageRouteBuilder {
  final Widget page;

  FadeScaleRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var curve = Curves.easeInOut;
            var curveTween = CurveTween(curve: curve);
            
            return FadeTransition(
              opacity: animation.drive(curveTween),
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.8, end: 1.0)
                    .animate(animation),
                child: child,
              ),
            );
          },
        );
} 