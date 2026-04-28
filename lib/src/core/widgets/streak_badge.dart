import 'package:flutter/material.dart';

import '../theme/app_palette.dart';

class StreakBadge extends StatelessWidget {
  const StreakBadge({required this.label, required this.count, super.key});

  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.96, end: 1),
      duration: const Duration(milliseconds: 420),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              context.palette.gold.withValues(alpha: 0.20),
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
            ],
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: context.palette.gold.withValues(alpha: 0.34),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.local_fire_department, color: context.palette.gold),
              const SizedBox(width: 8),
              Text(
                '$count $label',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
