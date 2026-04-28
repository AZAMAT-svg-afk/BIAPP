import 'package:flutter/material.dart';

import '../theme/app_palette.dart';

class PremiumIconBox extends StatelessWidget {
  const PremiumIconBox({
    required this.icon,
    this.color,
    this.size = 44,
    super.key,
  });

  final IconData icon;
  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final accent = color ?? Theme.of(context).colorScheme.primary;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.withValues(alpha: 0.18),
            context.palette.gold.withValues(alpha: 0.14),
          ],
        ),
        borderRadius: BorderRadius.circular(size * 0.34),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Icon(icon, color: accent, size: size * 0.48),
    );
  }
}
