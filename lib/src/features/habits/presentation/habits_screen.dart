import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_motion.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/gradient_action_button.dart';
import '../application/habits_controller.dart';
import '../domain/habit.dart';
import 'widgets/habit_card.dart';

class HabitsScreen extends ConsumerWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final habits = ref.watch(habitsControllerProvider);
    final controller = ref.read(habitsControllerProvider.notifier);

    return AppScaffold(
      title: l10n.habitsTitle,
      floatingActionButton: GradientActionButton(
        onPressed: () => _showHabitSheet(context, ref),
        icon: Icons.add,
        label: l10n.addHabit,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 150),
        children: [
          if (habits.isEmpty)
            AppEmptyState(message: l10n.emptyHabits, icon: Icons.track_changes)
          else
            ...habits.toList().asMap().entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AppMotion(
                  delay: Duration(milliseconds: 35 * entry.key),
                  child: HabitCard(
                    habit: entry.value,
                    onCheck: () => controller.checkHabit(entry.value.id),
                    onEdit: () =>
                        _showHabitSheet(context, ref, habit: entry.value),
                    onDelete: () => controller.deleteHabit(entry.value.id),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showHabitSheet(BuildContext context, WidgetRef ref, {Habit? habit}) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => _HabitFormSheet(habit: habit),
    );
  }
}

class _HabitFormSheet extends ConsumerStatefulWidget {
  const _HabitFormSheet({this.habit});

  final Habit? habit;

  @override
  ConsumerState<_HabitFormSheet> createState() => _HabitFormSheetState();
}

class _HabitFormSheetState extends ConsumerState<_HabitFormSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _categoryController;
  late int _targetPerDay;
  late bool _reminderEnabled;
  TimeOfDay? _reminderTime;

  @override
  void initState() {
    super.initState();
    final habit = widget.habit;
    _nameController = TextEditingController(text: habit?.name ?? '');
    _categoryController = TextEditingController(text: habit?.category ?? '');
    _targetPerDay = habit?.targetPerDay ?? 1;
    _reminderEnabled = habit?.reminderEnabled ?? false;
    _reminderTime = habit?.reminderTime;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final viewInsets = MediaQuery.viewInsetsOf(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, viewInsets.bottom + 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.habit == null ? l10n.addHabit : l10n.editHabit,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 18),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: l10n.habitName),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(labelText: l10n.category),
            ),
            const SizedBox(height: 12),
            Stepper(
              physics: const NeverScrollableScrollPhysics(),
              controlsBuilder: (context, details) => const SizedBox.shrink(),
              steps: [
                Step(
                  title: Text(l10n.targetPerDay),
                  content: Row(
                    children: [
                      IconButton(
                        onPressed: _targetPerDay > 1
                            ? () => setState(() => _targetPerDay--)
                            : null,
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      Text('$_targetPerDay'),
                      IconButton(
                        onPressed: () => setState(() => _targetPerDay++),
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _reminderEnabled,
              title: Text(l10n.reminderEnabled),
              onChanged: (value) => setState(() => _reminderEnabled = value),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.schedule),
              title: Text(_reminderTime?.format(context) ?? l10n.noTime),
              trailing: TextButton(
                onPressed: _pickTime,
                child: Text(l10n.choose),
              ),
            ),
            FilledButton(onPressed: _save, child: Text(l10n.save)),
          ],
        ),
      ),
    );
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _reminderTime = picked);
    }
  }

  void _save() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      return;
    }

    final controller = ref.read(habitsControllerProvider.notifier);
    if (widget.habit == null) {
      controller.addHabit(
        name: name,
        category: _categoryController.text,
        targetPerDay: _targetPerDay,
        reminderEnabled: _reminderEnabled,
        reminderTime: _reminderTime,
      );
    } else {
      controller.updateHabit(
        widget.habit!.copyWith(
          name: name,
          category: _categoryController.text,
          targetPerDay: _targetPerDay,
          reminderEnabled: _reminderEnabled,
          reminderTime: _reminderTime,
        ),
      );
    }

    Navigator.of(context).pop();
  }
}
