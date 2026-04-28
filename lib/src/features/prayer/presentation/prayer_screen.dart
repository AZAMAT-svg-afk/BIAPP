import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_motion.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/section_header.dart';
import '../../settings/application/settings_controller.dart';
import '../../settings/domain/user_settings.dart';
import '../application/prayer_controller.dart';
import '../domain/prayer_time.dart';
import 'prayer_labels.dart';
import 'widgets/prayer_card.dart';

class PrayerScreen extends ConsumerWidget {
  const PrayerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final schedule = ref.watch(prayerControllerProvider);
    final nextPrayer = ref.watch(nextPrayerProvider);
    final settings = ref.watch(settingsControllerProvider);
    final prayerSettings = settings.prayer;

    return AppScaffold(
      title: l10n.prayerTitle,
      backgroundMood: AppBackgroundMood.prayer,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
        children: [
          AppMotion(
            child: AppCard(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  context.palette.softCard.withValues(alpha: 0.96),
                  Color.alphaBlend(
                    context.palette.gold.withValues(alpha: 0.12),
                    context.palette.card,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.mosque,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.nextPrayer,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    PrayerLabels.name(l10n, nextPrayer.type),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  _Countdown(nextPrayer: nextPrayer),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),
          SectionHeader(title: l10n.todaySchedule),
          const SizedBox(height: 12),
          ...schedule.toList().asMap().entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AppMotion(
                delay: Duration(milliseconds: 35 * entry.key),
                child: PrayerCard(
                  item: entry.value,
                  status: statusForPrayer(
                    entry.value,
                    schedule,
                    DateTime.now(),
                  ),
                  onCompleted: () {
                    ref
                        .read(prayerControllerProvider.notifier)
                        .markCompleted(entry.value.type);
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          SectionHeader(title: l10n.prayerSettings),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.location_city),
                  title: Text(l10n.city),
                  subtitle: Text(prayerSettings.city),
                  trailing: TextButton(
                    onPressed: () => _editCity(context, ref, prayerSettings),
                    child: Text(l10n.edit),
                  ),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: prayerSettings.useGeolocation,
                  title: Text(l10n.geolocation),
                  onChanged: (value) {
                    _updatePrayer(
                      ref,
                      prayerSettings.copyWith(useGeolocation: value),
                    );
                  },
                ),
                DropdownButtonFormField<String>(
                  initialValue: prayerSettings.calculationMethod,
                  decoration: InputDecoration(
                    labelText: l10n.calculationMethod,
                  ),
                  items: const ['Muslim World League', 'Umm al-Qura', 'Karachi']
                      .map((method) {
                        return DropdownMenuItem(
                          value: method,
                          child: Text(method),
                        );
                      })
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      _updatePrayer(
                        ref,
                        prayerSettings.copyWith(calculationMethod: value),
                      );
                    }
                  },
                ),
                const SizedBox(height: 12),
                SegmentedButton<Madhhab>(
                  segments: [
                    ButtonSegment(
                      value: Madhhab.hanafi,
                      label: Text(l10n.hanafi),
                    ),
                    ButtonSegment(
                      value: Madhhab.shafii,
                      label: Text(l10n.shafii),
                    ),
                  ],
                  selected: {prayerSettings.madhhab},
                  onSelectionChanged: (value) {
                    _updatePrayer(
                      ref,
                      prayerSettings.copyWith(madhhab: value.first),
                    );
                  },
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: prayerSettings.notificationsEnabled,
                  title: Text(l10n.notifications),
                  onChanged: (value) {
                    _updatePrayer(
                      ref,
                      prayerSettings.copyWith(notificationsEnabled: value),
                    );
                  },
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: prayerSettings.soundEnabled,
                  title: Text(l10n.sound),
                  onChanged: (value) {
                    _updatePrayer(
                      ref,
                      prayerSettings.copyWith(soundEnabled: value),
                    );
                  },
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: prayerSettings.vibrationEnabled,
                  title: Text(l10n.vibration),
                  onChanged: (value) {
                    _updatePrayer(
                      ref,
                      prayerSettings.copyWith(vibrationEnabled: value),
                    );
                  },
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: prayerSettings.adhanEnabled,
                  title: Text(l10n.adhan),
                  onChanged: (value) {
                    _updatePrayer(
                      ref,
                      prayerSettings.copyWith(adhanEnabled: value),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _editCity(
    BuildContext context,
    WidgetRef ref,
    PrayerSettings settings,
  ) async {
    final controller = TextEditingController(text: settings.city);
    final l10n = AppLocalizations.of(context)!;
    final value = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.city),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: l10n.city),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: Text(l10n.save),
          ),
        ],
      ),
    );

    if (value != null && value.trim().isNotEmpty) {
      _updatePrayer(ref, settings.copyWith(city: value.trim()));
    }
    controller.dispose();
  }

  void _updatePrayer(WidgetRef ref, PrayerSettings prayer) {
    final current = ref.read(settingsControllerProvider);
    ref.read(settingsControllerProvider.notifier).updatePrayer(prayer);
    ref
        .read(settingsControllerProvider.notifier)
        .updateNotifications(current.notificationsEnabled);
  }
}

class _Countdown extends StatelessWidget {
  const _Countdown({required this.nextPrayer});

  final PrayerTimeItem nextPrayer;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return StreamBuilder<int>(
      stream: Stream.periodic(const Duration(seconds: 1), (tick) => tick),
      builder: (context, _) {
        final duration = nextPrayer.time.difference(DateTime.now());
        final value = _formatDuration(duration);
        return Text(
          l10n.timeUntilPrayer(value, PrayerLabels.name(l10n, nextPrayer.type)),
          style: Theme.of(context).textTheme.titleMedium,
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    final safeDuration = duration.isNegative ? Duration.zero : duration;
    final hours = safeDuration.inHours;
    final minutes = safeDuration.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }
}
