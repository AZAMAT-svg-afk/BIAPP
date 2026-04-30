import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../theme/app_palette.dart';
import 'app_card.dart';
import 'gradient_action_button.dart';

class AppDateTimePickers {
  const AppDateTimePickers._();

  static Future<DateTime?> pickDate({
    required BuildContext context,
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
  }) {
    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: _datePickerBuilder,
    );
  }

  static Future<TimeOfDay?> pickTime({
    required BuildContext context,
    required TimeOfDay initialTime,
  }) {
    return showModalBottomSheet<TimeOfDay>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.42),
      builder: (context) => _BarakaTimePickerSheet(initialTime: initialTime),
    );
  }

  static Widget _datePickerBuilder(BuildContext context, Widget? child) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final palette = context.palette;
    final isDark = theme.brightness == Brightness.dark;

    return Theme(
      data: theme.copyWith(
        colorScheme: scheme.copyWith(
          primary: palette.emerald,
          surface: isDark ? palette.card : palette.softCard,
          onSurface: scheme.onSurface,
          onPrimary: scheme.onPrimary,
        ),
        datePickerTheme: theme.datePickerTheme.copyWith(
          backgroundColor: isDark ? const Color(0xFF10212A) : palette.card,
          headerBackgroundColor: palette.emerald.withValues(
            alpha: isDark ? 0.22 : 0.14,
          ),
          headerForegroundColor: scheme.onSurface,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          cancelButtonStyle: TextButton.styleFrom(
            foregroundColor: scheme.onSurfaceVariant,
          ),
          confirmButtonStyle: TextButton.styleFrom(
            foregroundColor: palette.emerald,
            textStyle: theme.textTheme.labelLarge,
          ),
        ),
      ),
      child: child ?? const SizedBox.shrink(),
    );
  }
}

class _BarakaTimePickerSheet extends StatefulWidget {
  const _BarakaTimePickerSheet({required this.initialTime});

  final TimeOfDay initialTime;

  @override
  State<_BarakaTimePickerSheet> createState() => _BarakaTimePickerSheetState();
}

class _BarakaTimePickerSheetState extends State<_BarakaTimePickerSheet> {
  late int _hour;
  late int _minute;
  late final FixedExtentScrollController _hourController;
  late final FixedExtentScrollController _minuteController;

  static const _quickMinutes = [0, 5, 10, 15, 30, 45];

  @override
  void initState() {
    super.initState();
    _hour = widget.initialTime.hour;
    _minute = widget.initialTime.minute;
    _hourController = FixedExtentScrollController(initialItem: _hour);
    _minuteController = FixedExtentScrollController(initialItem: _minute);
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final palette = context.palette;
    final viewInsets = MediaQuery.viewInsetsOf(context);
    final selectedTime = '${_twoDigits(_hour)}:${_twoDigits(_minute)}';

    return Padding(
      padding: EdgeInsets.fromLTRB(12, 0, 12, viewInsets.bottom + 12),
      child: SingleChildScrollView(
        child: AppCard(
          borderRadius: 28,
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: scheme.outlineVariant,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: palette.emerald.withValues(alpha: 0.13),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: palette.emerald.withValues(alpha: 0.24),
                        ),
                      ),
                      child: Icon(
                        Icons.schedule_rounded,
                        color: palette.emerald,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        selectedTime,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: palette.emerald.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '24h',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: palette.emerald,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _TimeWheel(
                        label: 'HH',
                        itemCount: 24,
                        selectedValue: _hour,
                        controller: _hourController,
                        onSelectedItemChanged: (value) {
                          setState(() => _hour = value);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        ':',
                        style: theme.textTheme.headlineLarge?.copyWith(
                          color: palette.textMuted,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    Expanded(
                      child: _TimeWheel(
                        label: 'MM',
                        itemCount: 60,
                        selectedValue: _minute,
                        controller: _minuteController,
                        onSelectedItemChanged: (value) {
                          setState(() => _minute = value);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _quickMinutes.map((minute) {
                    return _MinuteChip(
                      minute: minute,
                      selected: _minute == minute,
                      onTap: () => _selectMinute(minute),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: scheme.onSurfaceVariant,
                          side: BorderSide(color: scheme.outlineVariant),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                        child: Text(l10n.cancel),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GradientActionButton(
                        label: l10n.save,
                        icon: Icons.check_rounded,
                        onPressed: () {
                          Navigator.of(
                            context,
                          ).pop(TimeOfDay(hour: _hour, minute: _minute));
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _selectMinute(int minute) {
    setState(() => _minute = minute);
    _minuteController.animateToItem(
      minute,
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOutCubic,
    );
  }
}

class _TimeWheel extends StatelessWidget {
  const _TimeWheel({
    required this.label,
    required this.itemCount,
    required this.selectedValue,
    required this.controller,
    required this.onSelectedItemChanged,
  });

  final String label;
  final int itemCount;
  final int selectedValue;
  final FixedExtentScrollController controller;
  final ValueChanged<int> onSelectedItemChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final palette = context.palette;

    return Column(
      children: [
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: palette.textMuted,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 148,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 44,
                decoration: BoxDecoration(
                  color: palette.emerald.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: palette.emerald.withValues(alpha: 0.28),
                  ),
                ),
              ),
              ListWheelScrollView.useDelegate(
                controller: controller,
                itemExtent: 44,
                physics: const FixedExtentScrollPhysics(),
                diameterRatio: 1.35,
                perspective: 0.002,
                squeeze: 1.02,
                overAndUnderCenterOpacity: 0.48,
                onSelectedItemChanged: onSelectedItemChanged,
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: itemCount,
                  builder: (context, index) {
                    final selected = index == selectedValue;
                    return Center(
                      child: Text(
                        _twoDigits(index),
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: selected ? palette.emerald : scheme.onSurface,
                          fontWeight: selected
                              ? FontWeight.w900
                              : FontWeight.w700,
                          letterSpacing: 0,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MinuteChip extends StatelessWidget {
  const _MinuteChip({
    required this.minute,
    required this.selected,
    required this.onTap,
  });

  final int minute;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final palette = context.palette;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: selected
              ? palette.emerald
              : scheme.surfaceContainerHighest.withValues(alpha: 0.62),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? palette.emerald : scheme.outlineVariant,
          ),
        ),
        child: Text(
          _twoDigits(minute),
          style: theme.textTheme.labelLarge?.copyWith(
            color: selected ? scheme.onPrimary : scheme.onSurface,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

String _twoDigits(int value) => value.toString().padLeft(2, '0');
