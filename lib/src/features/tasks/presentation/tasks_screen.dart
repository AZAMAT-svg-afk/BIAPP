import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_motion.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/gradient_action_button.dart';
import '../../../core/widgets/premium_icon_box.dart';
import '../../../core/widgets/section_header.dart';
import '../application/tasks_controller.dart';
import '../domain/task_item.dart';
import 'task_labels.dart';
import 'widgets/task_card.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final todayTasks = ref.watch(todayTasksProvider);
    final completed = ref.watch(completedTasksProvider);
    final missed = ref.watch(missedTasksProvider);
    final controller = ref.read(tasksControllerProvider.notifier);

    return AppScaffold(
      title: l10n.tasksTitle,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                _TasksHeader(
                  title: l10n.tasksTitle,
                  subtitle: l10n.tasksSubtitle,
                  onCalendarTap: () {},
                ),
                const SizedBox(height: 20),
                SectionHeader(title: l10n.today),
                const SizedBox(height: 12),
                if (todayTasks.isEmpty)
                  AppEmptyState(message: l10n.emptyTasks, icon: Icons.task_alt)
                else
                  ...todayTasks.toList().asMap().entries.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AppMotion(
                        delay: Duration(milliseconds: 35 * entry.key),
                        child: TaskCard(
                          key: ValueKey('today-${entry.value.id}'),
                          task: entry.value,
                          onToggle: () =>
                              controller.toggleComplete(entry.value.id),
                          onEdit: () =>
                              _showTaskSheet(context, ref, task: entry.value),
                          onDelete: () => controller.deleteTask(entry.value.id),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 18),
                SectionHeader(title: l10n.completedTasks),
                const SizedBox(height: 12),
                if (completed.isEmpty)
                  AppEmptyState(
                    message: l10n.emptyCompleted,
                    icon: Icons.done_all,
                  )
                else
                  ...completed
                      .take(4)
                      .toList()
                      .asMap()
                      .entries
                      .map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: AppMotion(
                            delay: Duration(milliseconds: 30 * entry.key),
                            child: TaskCard(
                              key: ValueKey('completed-${entry.value.id}'),
                              task: entry.value,
                              onToggle: () =>
                                  controller.toggleComplete(entry.value.id),
                              onEdit: () => _showTaskSheet(
                                context,
                                ref,
                                task: entry.value,
                              ),
                              onDelete: () =>
                                  controller.deleteTask(entry.value.id),
                            ),
                          ),
                        ),
                      ),
                const SizedBox(height: 18),
                SectionHeader(title: l10n.missedTasks),
                const SizedBox(height: 12),
                if (missed.isEmpty)
                  AppEmptyState(
                    message: l10n.noMissedTasks,
                    icon: Icons.event_busy,
                  )
                else
                  ...missed.toList().asMap().entries.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AppMotion(
                        delay: Duration(milliseconds: 30 * entry.key),
                        child: TaskCard(
                          key: ValueKey('missed-${entry.value.id}'),
                          task: entry.value,
                          onToggle: () =>
                              controller.toggleComplete(entry.value.id),
                          onEdit: () =>
                              _showTaskSheet(context, ref, task: entry.value),
                          onDelete: () => controller.deleteTask(entry.value.id),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            minimum: EdgeInsets.fromLTRB(
              20,
              8,
              20,
              MediaQuery.paddingOf(context).bottom + 88,
            ),
            child: SizedBox(
              width: double.infinity,
              child: GradientActionButton(
                label: l10n.addTask,
                icon: Icons.add,
                onPressed: () => _showTaskSheet(context, ref),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTaskSheet(BuildContext context, WidgetRef ref, {TaskItem? task}) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _TaskFormSheet(task: task),
    );
  }
}

class _TasksHeader extends StatelessWidget {
  const _TasksHeader({
    required this.title,
    required this.subtitle,
    required this.onCalendarTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onCalendarTap;

  @override
  Widget build(BuildContext context) {
    return AppMotion(
      child: AppCard(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.palette.card.withValues(alpha: 0.96),
            Color.alphaBlend(
              context.palette.emerald.withValues(alpha: 0.08),
              context.palette.softCard,
            ),
          ],
        ),
        child: Row(
          children: [
            const PremiumIconBox(icon: Icons.checklist_rtl),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: context.palette.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            IconButton.filledTonal(
              tooltip: MaterialLocalizations.of(context).showMenuTooltip,
              onPressed: onCalendarTap,
              icon: const Icon(Icons.calendar_month_outlined),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskFormSheet extends ConsumerStatefulWidget {
  const _TaskFormSheet({this.task});

  final TaskItem? task;

  @override
  ConsumerState<_TaskFormSheet> createState() => _TaskFormSheetState();
}

class _TaskFormSheetState extends ConsumerState<_TaskFormSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _categoryController;
  late TaskPriority _priority;
  late RepeatType _repeatType;
  late bool _reminderEnabled;
  late DateTime _date;
  TimeOfDay? _time;

  @override
  void initState() {
    super.initState();
    final task = widget.task;
    final now = DateTime.now();
    _titleController = TextEditingController(text: task?.title ?? '');
    _descriptionController = TextEditingController(
      text: task?.description ?? '',
    );
    _categoryController = TextEditingController(text: task?.category ?? '');
    _priority = task?.priority ?? TaskPriority.medium;
    _repeatType = task?.repeatType ?? RepeatType.none;
    _reminderEnabled = task?.reminderEnabled ?? false;
    _date = task?.date ?? DateTime(now.year, now.month, now.day);
    _time = task?.time;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final viewInsets = MediaQuery.viewInsetsOf(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(12, 0, 12, viewInsets.bottom + 12),
      child: SingleChildScrollView(
        child: AppCard(
          borderRadius: 28,
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
          child: SafeArea(
            top: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.task == null ? l10n.addTask : l10n.editTask,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: l10n.taskTitleField),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: l10n.description),
                  minLines: 2,
                  maxLines: 4,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _categoryController,
                  decoration: InputDecoration(labelText: l10n.category),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<TaskPriority>(
                  initialValue: _priority,
                  decoration: InputDecoration(labelText: l10n.priority),
                  items: TaskPriority.values.map((priority) {
                    return DropdownMenuItem(
                      value: priority,
                      child: Text(TaskLabels.priority(l10n, priority)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _priority = value);
                    }
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<RepeatType>(
                  initialValue: _repeatType,
                  decoration: InputDecoration(labelText: l10n.repeat),
                  items: RepeatType.values.map((repeatType) {
                    return DropdownMenuItem(
                      value: repeatType,
                      child: Text(TaskLabels.repeat(l10n, repeatType)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _repeatType = value);
                    }
                  },
                ),
                const SizedBox(height: 8),
                _PickerTile(
                  icon: Icons.calendar_today_outlined,
                  title: DateFormat.yMMMd(l10n.localeName).format(_date),
                  action: l10n.choose,
                  onTap: _pickDate,
                ),
                _PickerTile(
                  icon: Icons.schedule,
                  title: _time?.format(context) ?? l10n.noTime,
                  action: l10n.choose,
                  onTap: _pickTime,
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _reminderEnabled,
                  title: Text(l10n.reminderEnabled),
                  onChanged: (value) =>
                      setState(() => _reminderEnabled = value),
                ),
                const SizedBox(height: 12),
                GradientActionButton(
                  label: l10n.save,
                  icon: Icons.check,
                  onPressed: _save,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
    );
    if (picked != null) {
      setState(() => _date = DateTime(picked.year, picked.month, picked.day));
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _time = picked);
    }
  }

  void _save() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      return;
    }

    final controller = ref.read(tasksControllerProvider.notifier);

    if (widget.task == null) {
      controller.addTask(
        title: title,
        description: _descriptionController.text,
        date: _date,
        time: _time,
        priority: _priority,
        category: _categoryController.text,
        reminderEnabled: _reminderEnabled,
        repeatType: _repeatType,
      );
    } else {
      controller.updateTask(
        widget.task!.copyWith(
          title: title,
          description: _descriptionController.text,
          category: _categoryController.text,
          date: _date,
          time: _time,
          priority: _priority,
          reminderEnabled: _reminderEnabled,
          repeatType: _repeatType,
        ),
      );
    }

    Navigator.of(context).pop();
  }
}

class _PickerTile extends StatelessWidget {
  const _PickerTile({
    required this.icon,
    required this.title,
    required this.action,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: PremiumIconBox(icon: icon, size: 38),
      title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: TextButton(onPressed: onTap, child: Text(action)),
    );
  }
}
