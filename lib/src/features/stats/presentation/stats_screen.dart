import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_motion.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../habits/application/habits_controller.dart';
import '../../prayer/application/prayer_controller.dart';
import '../../streak/application/streak_controller.dart';
import '../../tasks/application/tasks_controller.dart';
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

    return AppScaffold(
      title: l10n.statsTitle,
      backgroundMood: AppBackgroundMood.stats,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 168),
        children: [
          AppMotion(child: _StatsHeader(stats: stats)),
          const SizedBox(height: 16),
          AppMotion(
            delay: const Duration(milliseconds: 40),
            child: _TodayOverviewCard(stats: stats),
          ),
          const SizedBox(height: 14),
          AppMotion(
            delay: const Duration(milliseconds: 70),
            child: _CompletionCard(stats: stats),
          ),
          const SizedBox(height: 14),
          AppMotion(
            delay: const Duration(milliseconds: 100),
            child: _WeeklyActivityCard(values: stats.weeklyActivity),
          ),
          const SizedBox(height: 22),
          _StatsSectionTitle(title: l10n.streaks),
          const SizedBox(height: 12),
          _StreakGrid(stats: stats),
          const SizedBox(height: 22),
          AppMotion(
            delay: const Duration(milliseconds: 130),
            child: _InsightsCard(stats: stats),
          ),
        ],
      ),
    );
  }
}

class _StatsHeader extends StatelessWidget {
  const _StatsHeader({required this.stats});

  final StatsSnapshot stats;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final progress = (stats.completionRate * 100).round();

    return Row(
      children: [
        _IconBadge(
          icon: Icons.insights,
          color: Theme.of(context).colorScheme.primary,
          size: 54,
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.statsTitle,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.statsSubtitle,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        _ProgressBadge(value: '$progress%'),
      ],
    );
  }
}

class _TodayOverviewCard extends StatelessWidget {
  const _TodayOverviewCard({required this.stats});

  final StatsSnapshot stats;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasActivity =
        stats.todayTasksTotal > 0 ||
        stats.completedTasksToday > 0 ||
        stats.missedTasks > 0;

    return AppCard(
      borderRadius: 28,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardHeader(
            icon: Icons.today_outlined,
            title: l10n.today,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          if (!hasActivity)
            _SoftEmptyState(
              icon: Icons.flag_outlined,
              message: l10n.statsTodayNoActivity,
            )
          else
            Row(
              children: [
                Expanded(
                  child: _CompactMetric(
                    icon: Icons.task_alt,
                    label: l10n.statsDone,
                    value: '${stats.completedTasksToday}',
                    color: context.palette.success,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _CompactMetric(
                    icon: Icons.event_busy_outlined,
                    label: l10n.statsMissed,
                    value: '${stats.missedTasks}',
                    color: context.palette.danger,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _CompactMetric(
                    icon: Icons.trending_up,
                    label: l10n.statsProgress,
                    value: '${(stats.completionRate * 100).round()}%',
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _CompletionCard extends StatelessWidget {
  const _CompletionCard({required this.stats});

  final StatsSnapshot stats;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasTasks = stats.todayTasksTotal > 0;

    return AppCard(
      borderRadius: 28,
      padding: const EdgeInsets.all(18),
      child: hasTasks
          ? Row(
              children: [
                _CompletionRing(progress: stats.completionRate),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.completion,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.statsTasksCount(
                          stats.completedTasksToday,
                          stats.todayTasksTotal,
                        ),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        stats.completionRate >= 1
                            ? l10n.statsGreatProgress
                            : l10n.statsCloseDayOneTask,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            )
          : _SoftEmptyState(
              icon: Icons.check_circle_outline,
              title: l10n.statsNoTasksToday,
              message: l10n.statsStartSmall,
            ),
    );
  }
}

class _WeeklyActivityCard extends StatelessWidget {
  const _WeeklyActivityCard({required this.values});

  final List<double> values;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final normalized = _safeWeekValues(values);
    final hasActivity = normalized.any((value) => value > 0.25);

    return AppCard(
      borderRadius: 28,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardHeader(
            icon: Icons.bar_chart_rounded,
            title: l10n.weekActivity,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          if (!hasActivity)
            _SoftEmptyState(
              icon: Icons.auto_graph_outlined,
              message: l10n.statsWeeklyNoData,
            )
          else
            _WeeklyActivityChart(values: normalized),
        ],
      ),
    );
  }

  List<double> _safeWeekValues(List<double> source) {
    final padded = [
      ...source.take(7).map((value) => value.clamp(0.0, 1.0).toDouble()),
    ];
    while (padded.length < 7) {
      padded.add(0);
    }
    return padded;
  }
}

class _WeeklyActivityChart extends StatelessWidget {
  const _WeeklyActivityChart({required this.values});

  final List<double> values;

  @override
  Widget build(BuildContext context) {
    final labels = _recentWeekdayLabels(AppLocalizations.of(context)!);
    const currentIndex = 6;

    return SizedBox(
      height: 158,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var index = 0; index < values.length; index++) ...[
            Expanded(
              child: _WeekBar(
                label: labels[index],
                value: values[index],
                isCurrent: index == currentIndex,
              ),
            ),
            if (index < values.length - 1) const SizedBox(width: 7),
          ],
        ],
      ),
    );
  }
}

class _WeekBar extends StatelessWidget {
  const _WeekBar({
    required this.label,
    required this.value,
    required this.isCurrent,
  });

  final String label;
  final double value;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final palette = context.palette;
    final percent = (value * 100).round();
    final barColor = isCurrent ? scheme.primary : palette.emerald;
    final trackColor = scheme.surfaceContainerHighest.withValues(alpha: 0.62);
    final height = math.max(10.0, value * 82);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            '$percent%',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: isCurrent ? scheme.primary : palette.textMuted,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: isCurrent ? 20 : 16,
          height: 88,
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            color: trackColor,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: isCurrent
                  ? scheme.primary.withValues(alpha: 0.34)
                  : scheme.outlineVariant,
            ),
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 380),
            curve: Curves.easeOutCubic,
            width: double.infinity,
            height: height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [barColor, Color.lerp(barColor, palette.gold, 0.28)!],
              ),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ),
        const SizedBox(height: 9),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: isCurrent ? scheme.primary : palette.textMuted,
            fontWeight: isCurrent ? FontWeight.w900 : FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _StreakGrid extends StatelessWidget {
  const _StreakGrid({required this.stats});

  final StatsSnapshot stats;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final items = [
      _StreakCardData(
        icon: Icons.task_alt,
        title: l10n.statsTaskStreakTitle,
        days: stats.taskStreak,
        hint: l10n.statsTaskStreakHint,
        color: context.palette.success,
      ),
      _StreakCardData(
        icon: Icons.track_changes,
        title: l10n.statsHabitStreakTitle,
        days: stats.habitStreak,
        hint: l10n.statsHabitStreakHint,
        color: Theme.of(context).colorScheme.primary,
      ),
      _StreakCardData(
        icon: Icons.mosque_outlined,
        title: l10n.statsPrayerStreakTitle,
        days: stats.prayerStreak,
        hint: l10n.statsPrayerStreakHint,
        color: context.palette.gold,
      ),
      _StreakCardData(
        icon: Icons.mobile_friendly_outlined,
        title: l10n.statsAppStreakTitle,
        days: stats.appStreak,
        hint: l10n.statsAppStreakHint,
        color: context.palette.emerald,
      ),
      _StreakCardData(
        icon: Icons.workspace_premium_outlined,
        title: l10n.statsPerfectDayStreakTitle,
        days: stats.perfectDayStreak,
        hint: l10n.statsPerfectDayStreakHint,
        color: context.palette.warning,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - 12) / 2;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final item in items)
              SizedBox(
                width: cardWidth,
                child: _StreakCard(data: item),
              ),
          ],
        );
      },
    );
  }
}

class _StreakCard extends StatelessWidget {
  const _StreakCard({required this.data});

  final _StreakCardData data;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppCard(
      borderRadius: 24,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IconBadge(icon: data.icon, color: data.color, size: 38),
          const SizedBox(height: 12),
          Text(
            data.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.statsDaysCount(data.days),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: data.color,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            data.hint,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _InsightsCard extends StatelessWidget {
  const _InsightsCard({required this.stats});

  final StatsSnapshot stats;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final best = _bestStreak(context, stats);
    final hasInsightData =
        best.days > 0 ||
        stats.completedTasksToday > 0 ||
        stats.completedHabitsToday > 0 ||
        stats.completedPrayersToday > 0;

    return AppCard(
      borderRadius: 28,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardHeader(
            icon: Icons.lightbulb_outline,
            title: l10n.insights,
            color: context.palette.gold,
          ),
          const SizedBox(height: 14),
          if (!hasInsightData)
            _SoftEmptyState(
              icon: Icons.tips_and_updates_outlined,
              message: l10n.statsInsightsEmpty,
            )
          else ...[
            _InsightRow(
              icon: best.icon,
              color: best.color,
              text: l10n.statsBestStreakInsight(best.title, best.days),
            ),
            const Divider(height: 24),
            _InsightRow(
              icon:
                  stats.todayTasksTotal == stats.completedTasksToday &&
                      stats.todayTasksTotal > 0
                  ? Icons.verified_outlined
                  : Icons.flag_outlined,
              color: Theme.of(context).colorScheme.primary,
              text:
                  stats.todayTasksTotal == stats.completedTasksToday &&
                      stats.todayTasksTotal > 0
                  ? l10n.statsGreatProgress
                  : l10n.statsCloseDayOneTask,
            ),
            const Divider(height: 24),
            _InsightRow(
              icon: Icons.workspace_premium_outlined,
              color: context.palette.warning,
              text: l10n.statsPerfectDayInsight,
            ),
          ],
        ],
      ),
    );
  }
}

class _CompactMetric extends StatelessWidget {
  const _CompactMetric({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 10),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: context.palette.textMuted,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompletionRing extends StatelessWidget {
  const _CompletionRing({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final percent = (progress * 100).round();
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 112,
      height: 112,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 104,
            height: 104,
            child: CircularProgressIndicator(
              value: progress.clamp(0, 1),
              strokeWidth: 10,
              strokeCap: StrokeCap.round,
              color: scheme.primary,
              backgroundColor: scheme.surfaceContainerHighest,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$percent%',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                AppLocalizations.of(context)!.statsProgress,
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  const _CardHeader({
    required this.icon,
    required this.title,
    required this.color,
  });

  final IconData icon;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _IconBadge(icon: icon, color: color, size: 38),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ],
    );
  }
}

class _StatsSectionTitle extends StatelessWidget {
  const _StatsSectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.34),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SoftEmptyState extends StatelessWidget {
  const _SoftEmptyState({
    required this.icon,
    required this.message,
    this.title,
  });

  final IconData icon;
  final String message;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainer.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            _IconBadge(icon: icon, color: scheme.primary, size: 42),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null) ...[
                    Text(
                      title!,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                  ],
                  Text(message, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InsightRow extends StatelessWidget {
  const _InsightRow({
    required this.icon,
    required this.color,
    required this.text,
  });

  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _IconBadge(icon: icon, color: color, size: 36),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({
    required this.icon,
    required this.color,
    required this.size,
  });

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(size * 0.34),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Icon(icon, color: color, size: size * 0.48),
    );
  }
}

class _ProgressBadge extends StatelessWidget {
  const _ProgressBadge({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.20)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.trending_up, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              value,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StreakCardData {
  const _StreakCardData({
    required this.icon,
    required this.title,
    required this.days,
    required this.hint,
    required this.color,
  });

  final IconData icon;
  final String title;
  final int days;
  final String hint;
  final Color color;
}

_StreakCardData _bestStreak(BuildContext context, StatsSnapshot stats) {
  final l10n = AppLocalizations.of(context)!;
  final candidates = [
    _StreakCardData(
      icon: Icons.task_alt,
      title: l10n.statsTaskStreakTitle,
      days: stats.taskStreak,
      hint: '',
      color: context.palette.success,
    ),
    _StreakCardData(
      icon: Icons.track_changes,
      title: l10n.statsHabitStreakTitle,
      days: stats.habitStreak,
      hint: '',
      color: Theme.of(context).colorScheme.primary,
    ),
    _StreakCardData(
      icon: Icons.mosque_outlined,
      title: l10n.statsPrayerStreakTitle,
      days: stats.prayerStreak,
      hint: '',
      color: context.palette.gold,
    ),
    _StreakCardData(
      icon: Icons.mobile_friendly_outlined,
      title: l10n.statsAppStreakTitle,
      days: stats.appStreak,
      hint: '',
      color: context.palette.emerald,
    ),
    _StreakCardData(
      icon: Icons.workspace_premium_outlined,
      title: l10n.statsPerfectDayStreakTitle,
      days: stats.perfectDayStreak,
      hint: '',
      color: context.palette.warning,
    ),
  ];

  return candidates.reduce((a, b) => a.days >= b.days ? a : b);
}

List<String> _recentWeekdayLabels(AppLocalizations l10n) {
  final today = DateTime.now();
  return [
    for (var offset = 6; offset >= 0; offset--)
      _weekdayShortLabel(l10n, today.subtract(Duration(days: offset)).weekday),
  ];
}

String _weekdayShortLabel(AppLocalizations l10n, int weekday) {
  return switch (weekday) {
    DateTime.monday => l10n.statsMondayShort,
    DateTime.tuesday => l10n.statsTuesdayShort,
    DateTime.wednesday => l10n.statsWednesdayShort,
    DateTime.thursday => l10n.statsThursdayShort,
    DateTime.friday => l10n.statsFridayShort,
    DateTime.saturday => l10n.statsSaturdayShort,
    _ => l10n.statsSundayShort,
  };
}
