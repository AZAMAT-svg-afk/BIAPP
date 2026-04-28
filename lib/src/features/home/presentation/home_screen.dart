import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../app/shell/app_destination.dart';
import '../../../app/shell/app_shell.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_motion.dart';
import '../../../core/widgets/metric_ring.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/streak_badge.dart';
import '../../prayer/application/prayer_controller.dart';
import '../../prayer/presentation/prayer_labels.dart';
import '../../settings/application/settings_controller.dart';
import '../../stats/presentation/stats_screen.dart';
import '../../tasks/application/tasks_controller.dart';
import '../../tasks/presentation/task_labels.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsControllerProvider);
    final todayTasks = ref.watch(todayTasksProvider);
    final nextPrayer = ref.watch(nextPrayerProvider);
    final stats = ref.watch(statsSnapshotProvider);
    final completed = todayTasks.where((task) => task.isCompleted).length;
    final motivation = _motivation(l10n);

    return AppBackground(
      mood: AppBackgroundMood.home,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
          children: [
            _HomeHero(
              greeting: l10n.greetingName(settings.userName),
              date: DateFormat.yMMMMEEEEd(
                settings.language.code,
              ).format(DateTime.now()),
              motivation: motivation,
              streak: stats.appStreak,
              daysLabel: l10n.days,
            ),
            const SizedBox(height: 18),
            AppMotion(
              delay: const Duration(milliseconds: 80),
              child: AppCard(
                onTap: () => _go(ref, AppDestination.prayer),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    context.palette.card.withValues(alpha: 0.96),
                    Color.alphaBlend(
                      context.palette.gold.withValues(alpha: 0.10),
                      context.palette.softCard,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    _GradientIcon(
                      icon: Icons.mosque,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.nextPrayer,
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(color: context.palette.textMuted),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            PrayerLabels.name(l10n, nextPrayer.type),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          _CountdownText(target: nextPrayer.time),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            AppMotion(
              delay: const Duration(milliseconds: 130),
              child: AppCard(
                onTap: () => _go(ref, AppDestination.tasks),
                child: Row(
                  children: [
                    MetricRing(
                      progress: todayTasks.isEmpty
                          ? 0
                          : completed / todayTasks.length,
                      label: l10n.tasksTab,
                      value: '$completed/${todayTasks.length}',
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.tasksToday,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(999),
                            child: LinearProgressIndicator(
                              value: todayTasks.isEmpty
                                  ? 0
                                  : completed / todayTasks.length,
                              minHeight: 10,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(l10n.taskProgress(completed, todayTasks.length)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 22),
            AppMotion(
              delay: const Duration(milliseconds: 170),
              child: SectionHeader(title: l10n.quickActions),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _QuickAction(
                  label: l10n.addTask,
                  icon: Icons.add_task,
                  onTap: () => _go(ref, AppDestination.tasks),
                ),
                _QuickAction(
                  label: l10n.addNote,
                  icon: Icons.note_add,
                  onTap: () => _go(ref, AppDestination.notes),
                ),
                _QuickAction(
                  label: l10n.openAi,
                  icon: Icons.auto_awesome,
                  onTap: () => _go(ref, AppDestination.ai),
                ),
                _QuickAction(
                  label: l10n.openPrayer,
                  icon: Icons.mosque,
                  onTap: () => _go(ref, AppDestination.prayer),
                ),
                _QuickAction(
                  label: l10n.openStats,
                  icon: Icons.insights,
                  onTap: () => _go(ref, AppDestination.stats),
                ),
                _QuickAction(
                  label: l10n.habitsTitle,
                  icon: Icons.track_changes,
                  onTap: () => _go(ref, AppDestination.habits),
                ),
              ],
            ),
            const SizedBox(height: 22),
            SectionHeader(title: l10n.today),
            const SizedBox(height: 12),
            if (todayTasks.isEmpty)
              AppEmptyState(message: l10n.emptyTasks, icon: Icons.task_alt)
            else
              ...todayTasks
                  .take(3)
                  .map(
                    (task) => AppMotion(
                      delay: const Duration(milliseconds: 40),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          task.isCompleted
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: task.isCompleted
                              ? context.palette.success
                              : Theme.of(context).colorScheme.outline,
                        ),
                        title: Text(TaskLabels.title(l10n, task)),
                        subtitle: Text(
                          TaskLabels.priority(l10n, task.priority),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  void _go(WidgetRef ref, AppDestination destination) {
    ref.read(appDestinationProvider.notifier).setDestination(destination);
  }

  String _motivation(AppLocalizations l10n) {
    final items = [
      l10n.motivationOne,
      l10n.motivationTwo,
      l10n.motivationThree,
      l10n.motivationFour,
    ];
    final index = DateTime.now().millisecondsSinceEpoch % items.length;
    return items[index];
  }
}

class _HomeHero extends StatelessWidget {
  const _HomeHero({
    required this.greeting,
    required this.date,
    required this.motivation,
    required this.streak,
    required this.daysLabel,
  });

  final String greeting;
  final String date;
  final String motivation;
  final int streak;
  final String daysLabel;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final scheme = Theme.of(context).colorScheme;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 620),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 16 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.alphaBlend(
                palette.emerald.withValues(alpha: 0.18),
                scheme.surface,
              ),
              Color.alphaBlend(
                palette.gold.withValues(alpha: 0.12),
                scheme.surface,
              ),
            ],
          ),
          border: Border.all(color: scheme.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: palette.emerald.withValues(alpha: 0.10),
              blurRadius: 34,
              offset: const Offset(0, 18),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        greeting,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 6),
                      Text(date, style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ),
                StreakBadge(label: daysLabel, count: streak),
              ],
            ),
            const SizedBox(height: 18),
            Text(motivation, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}

class _GradientIcon extends StatelessWidget {
  const _GradientIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.18),
            context.palette.gold.withValues(alpha: 0.14),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(icon, color: color),
    );
  }
}

class _CountdownText extends StatelessWidget {
  const _CountdownText({required this.target});

  final DateTime target;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: Stream.periodic(const Duration(seconds: 1), (value) => value),
      builder: (context, snapshot) {
        final duration = target.difference(DateTime.now());
        final safe = duration.isNegative ? Duration.zero : duration;
        return Text(
          '${safe.inHours}h ${safe.inMinutes.remainder(60)}m',
          style: Theme.of(context).textTheme.bodyMedium,
        );
      },
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(12),
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
