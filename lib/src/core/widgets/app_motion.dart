import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AppMotion extends StatelessWidget {
  const AppMotion({
    required this.child,
    this.delay = Duration.zero,
    this.distance = 14,
    super.key,
  });

  final Widget child;
  final Duration delay;
  final double distance;

  @override
  Widget build(BuildContext context) {
    return child
        .animate(delay: delay)
        .fadeIn(duration: 360.ms, curve: Curves.easeOutCubic)
        .slideY(
          begin: distance / 100,
          end: 0,
          duration: 420.ms,
          curve: Curves.easeOutCubic,
        );
  }
}

class AppPulse extends StatelessWidget {
  const AppPulse({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .fade(begin: 0.58, end: 1, duration: 900.ms, curve: Curves.easeInOut);
  }
}
