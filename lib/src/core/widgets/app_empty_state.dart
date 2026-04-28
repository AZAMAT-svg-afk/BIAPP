import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../theme/app_palette.dart';
import 'app_card.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.action,
    super.key,
  });

  final String message;
  final IconData icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AppCard(
      color: context.palette.glass,
      child: Column(
        children: [
          SizedBox(
            width: 118,
            height: 92,
            child: Lottie.asset(
              'assets/animations/empty_state.json',
              repeat: true,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        scheme.primary.withValues(alpha: 0.18),
                        scheme.secondary.withValues(alpha: 0.16),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(icon, color: scheme.primary),
                );
              },
            ),
          ),
          const SizedBox(height: 14),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (action != null) ...[const SizedBox(height: 14), action!],
        ],
      ),
    );
  }
}
