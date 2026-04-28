import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_motion.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/metric_ring.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/stats_card.dart';
import '../../habits/application/habits_controller.dart';
import '../../habits/presentation/habit_labels.dart';
import '../../prayer/application/prayer_controller.dart';
import '../../streak/application/streak_controller.dart';
import '../../tasks/application/tasks_controller.dart';
import '../../tasks/presentation/task_labels.dart';
import '../data/stats_repository.dart';
import '../domain/stats_snapshot.dart';

final statsRepositoryProvider = Provider<StatsRepository>(
  (ref) => StatsRepository(),
);

final statsSnapshotProvider = Provider<StatsSnapshot>((ref) {
  return ref
      .read(statsRepositoryProvider)
      .buildSnapshot(
        allTasks: ref.watch(tasksControllerProvider),
        todayTasks: ref.watch(todayTasksProvider),
        missedTasks: ref.watch(missedTasksProvider),
        habits: ref.watch(habitsControllerProvider),
        prayers: ref.watch(prayerControllerProvider),
        streakSummary: ref.watch(streakSummaryProvider),
      );
});

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final stats = ref.watch(statsSnapshotProvider);
    final stableHabit = stats.stableHabit;
    final missedTask = stats.mostMissedTask;

    return AppScaffold(
      title: l10n.statsTitle,
      backgroundMood: AppBackgroundMood.stats,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 150),
        children: [
          AppMotion(
            child: Row(
              children: [
                Expanded(
                  child: StatsCard(
                    title: l10n.tasksDoneToday,
                    value: '${stats.completedTasksToday}',
                    icon: Icons.task_alt,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatsCard(
                    title: l10n.tasksMissed,
                    value: '${stats.missedTasks}',
                    icon: Icons.event_busy,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppMotion(
            delay: const Duration(milliseconds: 70),
            child: AppCard(
              child: Row(
                children: [
                  MetricRing(
                    progress: stats.completionRate,
                    label: l10n.completion,
                    value: '${(stats.completionRate * 100).round()}%',
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.weekActivity,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        _WeekBars(values: stats.weeklyActivity),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),
          SectionHeader(title: l10n.streaks),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _AnimatedChip(label: l10n.taskStreak(stats.taskStreak)),
              _AnimatedChip(label: l10n.habitStreak(stats.habitStreak)),
              _AnimatedChip(label: l10n.prayerStreak(stats.prayerStreak)),
              _AnimatedChip(label: l10n.appStreak(stats.appStreak)),
              _AnimatedChip(
                label: l10n.perfectDayStreak(stats.perfectDayStreak),
              ),
            ],
          ),
          const SizedBox(height: 22),
          SectionHeader(title: l10n.insights),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InsightRow(
                  icon: Icons.calendar_today,
                  title: l10n.bestWeekday,
                  value: _weekdayLabel(l10n, stats.bestWeekdayIndex),
                ),
                const Divider(height: 26),
                _InsightRow(
                  icon: Icons.track_changes,
                  title: l10n.stableHabit,
                  value: stableHabit == null
                      ? l10n.noData
                      : HabitLabels.name(l10n, stableHabit),
                ),
                const Divider(height: 26),
                _InsightRow(
                  icon: Icons.warning_amber,
                  title: l10n.mostMissedTask,
                  value: missedTask == null
                      ? l10n.noData
                      : TaskLabels.title(l10n, missedTask),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _weekdayLabel(AppLocalizations l10n, int index) {
    return switch (index) {
      1 => l10n.monday,
      2 => l10n.tuesday,
      3 => l10n.wednesday,
      4 => l10n.thursday,
      5 => l10n.friday,
      6 => l10n.saturday,
      _ => l10n.sunday,
    };
  }
}

class _WeekBars extends StatelessWidget {
  const _WeekBars({required this.values});

  final List<double> values;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 86,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final value in values)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: value.clamp(0.08, 1)),
                  duration: const Duration(milliseconds: 620),
                  curve: Curves.easeOutCubic,
                  builder: (context, animated, child) {
                    return FractionallySizedBox(
                      heightFactor: animated,
                      alignment: Alignment.bottomCenter,
                      child: child,
                    );
                  },
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AnimatedChip extends StatelessWidget {
  const _AnimatedChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return AppMotion(
      distance: 8,
      child: Chip(
        avatar: Icon(
          Icons.local_fire_department,
          size: 16,
          color: Theme.of(context).colorScheme.secondary,
        ),
        label: Text(label),
      ),
    );
  }
}

class _InsightRow extends StatelessWidget {
  const _InsightRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(child: Text(title)),
        Text(value, style: Theme.of(context).textTheme.labelLarge),
      ],
    );
  }
}
