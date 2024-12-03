import 'package:flutter/material.dart';

class HeroCard extends StatelessWidget {
  final String tag;
  final Widget child;
  final VoidCallback onTap;

  const HeroCard({
    required this.tag,
    required this.child,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      flightShuttleBuilder: (
        BuildContext flightContext,
        Animation<double> animation,
        HeroFlightDirection flightDirection,
        BuildContext fromHeroContext,
        BuildContext toHeroContext,
      ) {
        return Material(
          color: Colors.transparent,
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Transform.scale(
                scale: Tween<double>(
                  begin: flightDirection == HeroFlightDirection.push ? 0.9 : 1.1,
                  end: 1.0,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                )).value,
                child: Opacity(
                  opacity: animation.value,
                  child: child,
                ),
              );
            },
            child: child,
          ),
        );
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: child,
        ),
      ),
    );
  }
} 