import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/prayer_time.dart';
import '../prayer_labels.dart';

class PrayerCard extends StatelessWidget {
  const PrayerCard({
    required this.item,
    required this.status,
    required this.onCompleted,
    super.key,
  });

  final PrayerTimeItem item;
  final PrayerStatus status;
  final VoidCallback onCompleted;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = switch (status) {
      PrayerStatus.current => context.palette.gold,
      PrayerStatus.upcoming => Theme.of(context).colorScheme.primary,
      PrayerStatus.past => Theme.of(context).colorScheme.outline,
    };
    final time = DateFormat.Hm().format(item.time);

    return AppCard(
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.14),
            child: Icon(Icons.mosque, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  PrayerLabels.name(l10n, item.type),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  PrayerLabels.status(l10n, status),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Text(time, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(width: 8),
          Checkbox(value: item.isCompleted, onChanged: (_) => onCompleted()),
        ],
      ),
    );
  }
}
