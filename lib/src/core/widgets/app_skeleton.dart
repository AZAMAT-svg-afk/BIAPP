import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme/app_palette.dart';

class AppSkeletonLine extends StatelessWidget {
  const AppSkeletonLine({this.width = 120, this.height = 12, super.key});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final color = context.palette.glass.withValues(alpha: 0.70);
    return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(999),
          ),
        )
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .shimmer(duration: 1200.ms, color: Colors.white.withValues(alpha: 0.22))
        .fade(begin: 0.58, end: 1, duration: 900.ms);
  }
}
