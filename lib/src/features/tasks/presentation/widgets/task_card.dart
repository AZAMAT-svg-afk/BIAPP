import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/app_chip.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/task_item.dart';
import '../task_labels.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    required this.task,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final TaskItem task;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final priorityColor = switch (task.priority) {
      TaskPriority.low => context.palette.success,
      TaskPriority.medium => context.palette.warning,
      TaskPriority.high => context.palette.danger,
    };

    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Transform.scale(
            scale: 1.05,
            child: Checkbox(
              value: task.isCompleted,
              onChanged: (_) => onToggle(),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  TaskLabels.title(l10n, task),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                if (TaskLabels.description(l10n, task).isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    TaskLabels.description(l10n, task),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    AppChip(
                      label: TaskLabels.priority(l10n, task.priority),
                      color: priorityColor,
                    ),
                    if (task.time != null)
                      AppChip(
                        label: task.time!.format(context),
                        color: Theme.of(context).colorScheme.primary,
                        icon: Icons.schedule,
                      ),
                    if (task.reminderEnabled)
                      AppChip(
                        label: l10n.reminder,
                        color: context.palette.gold,
                        icon: Icons.notifications_active_outlined,
                      ),
                  ],
                ),
              ],
            ),
          ),
          PopupMenuButton<_TaskAction>(
            onSelected: (action) {
              switch (action) {
                case _TaskAction.edit:
                  onEdit();
                case _TaskAction.delete:
                  onDelete();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: _TaskAction.edit, child: Text(l10n.edit)),
              PopupMenuItem(
                value: _TaskAction.delete,
                child: Text(l10n.delete),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

enum _TaskAction { edit, delete }
