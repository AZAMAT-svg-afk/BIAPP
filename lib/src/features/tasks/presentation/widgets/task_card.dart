import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_chip.dart';
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

    return Dismissible(
      key: ValueKey(task.id),
      direction: DismissDirection.startToEnd,
      confirmDismiss: (_) async {
        onToggle();
        return false;
      },
      background: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              context.palette.success.withValues(alpha: 0.70),
              context.palette.success.withValues(alpha: 0.12),
            ],
          ),
          borderRadius: BorderRadius.circular(22),
        ),
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 22),
            child: Icon(Icons.check_circle_outline, color: Colors.white),
          ),
        ),
      ),
      child: AppCard(
        padding: EdgeInsets.zero,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                width: 5,
                decoration: BoxDecoration(
                  color: priorityColor,
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(22),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(13, 13, 10, 13),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _AnimatedCheckmark(
                        checked: task.isCompleted,
                        color: priorityColor,
                        onTap: onToggle,
                      ),
                      const SizedBox(width: 11),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              TaskLabels.title(l10n, task),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    decoration: task.isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                    fontWeight: FontWeight.w900,
                                  ),
                            ),
                            if (TaskLabels.description(
                              l10n,
                              task,
                            ).isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                TaskLabels.description(l10n, task),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                            const SizedBox(height: 9),
                            Wrap(
                              spacing: 7,
                              runSpacing: 7,
                              children: [
                                AppChip(
                                  label: TaskLabels.priority(
                                    l10n,
                                    task.priority,
                                  ),
                                  color: priorityColor,
                                ),
                                if (task.time != null)
                                  AppChip(
                                    label: task.time!.format(context),
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    icon: Icons.schedule_outlined,
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
                        icon: const Icon(Icons.more_horiz),
                        onSelected: (action) {
                          switch (action) {
                            case _TaskAction.edit:
                              onEdit();
                            case _TaskAction.delete:
                              onDelete();
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: _TaskAction.edit,
                            child: Text(l10n.edit),
                          ),
                          PopupMenuItem(
                            value: _TaskAction.delete,
                            child: Text(l10n.delete),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedCheckmark extends StatelessWidget {
  const _AnimatedCheckmark({
    required this.checked,
    required this.color,
    required this.onTap,
  });

  final bool checked;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      checked: checked,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutBack,
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: checked ? color : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
            boxShadow: checked
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.28),
                      blurRadius: 14,
                      offset: const Offset(0, 7),
                    ),
                  ]
                : null,
          ),
          child: AnimatedScale(
            scale: checked ? 1 : 0,
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutBack,
            child: const Icon(Icons.check, color: Colors.white, size: 18),
          ),
        ),
      ),
    );
  }
}

enum _TaskAction { edit, delete }
