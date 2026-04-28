import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_motion.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/gradient_action_button.dart';
import '../../../core/widgets/section_header.dart';
import '../../settings/application/settings_controller.dart';
import '../../settings/domain/user_settings.dart';
import '../application/prayer_controller.dart';
import '../data/prayer_repository.dart';
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
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 150),
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
                  SizedBox(
                    height: 74,
                    width: double.infinity,
                    child: CustomPaint(
                      painter: _MosqueSilhouettePainter(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
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
                  subtitle: Text(
                    KazakhstanPrayerCity.resolve(
                      prayerSettings.city,
                    ).displayName,
                  ),
                  trailing: TextButton(
                    onPressed: () =>
                        _showCitySelector(context, ref, prayerSettings),
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
                  items: const ['Muslim World League', 'Karachi'].map((method) {
                    return DropdownMenuItem(value: method, child: Text(method));
                  }).toList(),
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

  Future<void> _showCitySelector(
    BuildContext context,
    WidgetRef ref,
    PrayerSettings settings,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final selected = KazakhstanPrayerCity.resolve(settings.city);
    final value = await showModalBottomSheet<KazakhstanPrayerCity>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        child: AppCard(
          borderRadius: 28,
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 16),
                Text(l10n.city, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: KazakhstanPrayerCity.cities.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final city = KazakhstanPrayerCity.cities[index];
                      final isSelected =
                          city.displayName == selected.displayName;
                      return ListTile(
                        leading: Icon(
                          isSelected
                              ? Icons.location_on
                              : Icons.location_city_outlined,
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : null,
                        ),
                        title: Text(city.displayName),
                        subtitle: Text(city.timezone),
                        trailing: isSelected
                            ? const Icon(Icons.check_circle)
                            : null,
                        onTap: () => Navigator.of(context).pop(city),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                GradientActionButton(
                  label: l10n.cancel,
                  icon: Icons.close,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (value != null) {
      _updatePrayer(ref, settings.copyWith(city: value.displayName));
    }
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

class _MosqueSilhouettePainter extends CustomPainter {
  const _MosqueSilhouettePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final baseY = size.height * 0.82;
    final path = Path()
      ..moveTo(size.width * 0.08, baseY)
      ..lineTo(size.width * 0.18, baseY)
      ..lineTo(size.width * 0.18, size.height * 0.42)
      ..quadraticBezierTo(
        size.width * 0.22,
        size.height * 0.30,
        size.width * 0.26,
        size.height * 0.42,
      )
      ..lineTo(size.width * 0.26, baseY)
      ..lineTo(size.width * 0.38, baseY)
      ..lineTo(size.width * 0.38, size.height * 0.50)
      ..quadraticBezierTo(
        size.width * 0.50,
        size.height * 0.18,
        size.width * 0.62,
        size.height * 0.50,
      )
      ..lineTo(size.width * 0.62, baseY)
      ..lineTo(size.width * 0.74, baseY)
      ..lineTo(size.width * 0.74, size.height * 0.42)
      ..quadraticBezierTo(
        size.width * 0.78,
        size.height * 0.30,
        size.width * 0.82,
        size.height * 0.42,
      )
      ..lineTo(size.width * 0.82, baseY)
      ..lineTo(size.width * 0.92, baseY)
      ..lineTo(size.width * 0.92, size.height)
      ..lineTo(size.width * 0.08, size.height)
      ..close();
    canvas.drawPath(path, paint);

    final moonPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..color = color.withValues(alpha: 0.78);
    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(size.width * 0.50, size.height * 0.20),
        radius: 16,
      ),
      -1.2,
      3.4,
      false,
      moonPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _MosqueSilhouettePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
