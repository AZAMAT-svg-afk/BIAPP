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
    final highlighted =
        status == PrayerStatus.current || status == PrayerStatus.upcoming;

    return AppCard(
      gradient: highlighted
          ? LinearGradient(
              colors: [
                color.withValues(alpha: 0.18),
                context.palette.glass.withValues(alpha: 0.34),
              ],
            )
          : null,
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 260),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.16),
              shape: BoxShape.circle,
              boxShadow: highlighted
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.24),
                        blurRadius: 22,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : null,
            ),
            child: Icon(_iconFor(item.type), color: color),
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
          IconButton(
            onPressed: onCompleted,
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: Icon(
                item.isCompleted
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                key: ValueKey(item.isCompleted),
                color: item.isCompleted ? context.palette.success : color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(PrayerType type) {
    return switch (type) {
      PrayerType.fajr => Icons.wb_twilight_outlined,
      PrayerType.sunrise => Icons.wb_sunny_outlined,
      PrayerType.dhuhr => Icons.light_mode_outlined,
      PrayerType.asr => Icons.wb_cloudy_outlined,
      PrayerType.maghrib => Icons.nights_stay_outlined,
      PrayerType.isha => Icons.dark_mode_outlined,
    };
  }
}
