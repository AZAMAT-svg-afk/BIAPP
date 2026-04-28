import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/metric_ring.dart';
import '../../domain/habit.dart';
import '../habit_labels.dart';

class HabitCard extends StatelessWidget {
  const HabitCard({
    required this.habit,
    required this.onCheck,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final Habit habit;
  final VoidCallback onCheck;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppCard(
      child: Row(
        children: [
          MetricRing(
            progress: habit.progress,
            value: '${(habit.progress * 100).round()}%',
            label: l10n.today,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  HabitLabels.name(l10n, habit),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.habitProgress(habit.completedToday, habit.targetPerDay),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.streakDays(habit.streak),
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton.filledTonal(
                onPressed: habit.isCompletedToday ? null : onCheck,
                icon: const Icon(Icons.done),
              ),
              PopupMenuButton<_HabitAction>(
                onSelected: (action) {
                  switch (action) {
                    case _HabitAction.edit:
                      onEdit();
                    case _HabitAction.delete:
                      onDelete();
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: _HabitAction.edit,
                    child: Text(l10n.edit),
                  ),
                  PopupMenuItem(
                    value: _HabitAction.delete,
                    child: Text(l10n.delete),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

enum _HabitAction { edit, delete }
