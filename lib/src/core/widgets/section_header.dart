import 'package:flutter/material.dart';

import '../theme/app_palette.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({required this.title, this.action, super.key});

  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 8 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 6),
                Container(
                  width: 42,
                  height: 3,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        context.palette.emerald,
                        const Color(0xFF4CAF50),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ],
            ),
          ),
          ?action,
        ],
      ),
    );
  }
}

class AppSectionHeader extends SectionHeader {
  const AppSectionHeader({required super.title, super.action, super.key});
}
