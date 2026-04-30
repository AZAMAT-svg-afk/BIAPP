import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../settings/domain/user_settings.dart';
import '../../data/prayer_repository.dart';
import '../../domain/prayer_time.dart';
import '../prayer_labels.dart';

class PrayerOffsetEditor extends StatelessWidget {
  const PrayerOffsetEditor({
    required this.settings,
    required this.onChanged,
    super.key,
  });

  final PrayerSettings settings;
  final ValueChanged<PrayerSettings> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final offsets = settings.manualOffsets;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: settings.manualOffsetsEnabled,
          title: Text(l10n.manualPrayerCorrection),
          subtitle: Text(l10n.prayerCorrectionExplanation),
          onChanged: (value) {
            onChanged(settings.copyWith(manualOffsetsEnabled: value));
          },
        ),
        const SizedBox(height: 6),
        for (final type in PrayerType.values)
          _OffsetSlider(
            type: type,
            enabled: settings.manualOffsetsEnabled,
            value: offsets.forType(type),
            onChanged: (value) {
              onChanged(
                settings.copyWith(
                  manualOffsets: offsets.copyForType(type, value),
                ),
              );
            },
          ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: settings.manualOffsets.isZero
                ? null
                : () => onChanged(
                    settings.copyWith(manualOffsets: PrayerOffsets.zero),
                  ),
            icon: const Icon(Icons.restart_alt),
            label: Text(l10n.resetPrayerCorrection),
          ),
        ),
      ],
    );
  }
}

class _OffsetSlider extends StatelessWidget {
  const _OffsetSlider({
    required this.type,
    required this.enabled,
    required this.value,
    required this.onChanged,
  });

  final PrayerType type;
  final bool enabled;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final label = PrayerLabels.name(l10n, type);
    final valueLabel = value > 0 ? '+$value min' : '$value min';

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(label, style: theme.textTheme.labelLarge)),
              Text(valueLabel, style: theme.textTheme.labelLarge),
            ],
          ),
          Slider(
            value: value.toDouble(),
            min: -30,
            max: 30,
            divisions: 60,
            label: valueLabel,
            onChanged: enabled ? (next) => onChanged(next.round()) : null,
          ),
        ],
      ),
    );
  }
}
