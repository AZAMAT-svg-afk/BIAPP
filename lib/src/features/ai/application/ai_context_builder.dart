import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../habits/application/habits_controller.dart';
import '../../habits/presentation/habit_labels.dart';
import '../../prayer/application/prayer_controller.dart';
import '../../prayer/presentation/prayer_labels.dart';
import '../../settings/application/settings_controller.dart';
import '../../stats/presentation/stats_screen.dart';
import '../../tasks/application/tasks_controller.dart';
import '../../tasks/presentation/task_labels.dart';
import '../domain/ai_message.dart';

final aiContextBuilderProvider = Provider<AiContextBuilder>(
  (ref) => AiContextBuilder(ref),
);

class AiContextBuilder {
  const AiContextBuilder(this._ref);

  final Ref _ref;

  AiUserContext build(AppLocalizations l10n) {
    final settings = _ref.read(settingsControllerProvider);
    final todayTasks = _ref.read(todayTasksProvider);
    final completedTasks = todayTasks
        .where((task) => task.isCompleted)
        .toList();
    final missedTasks = _ref.read(missedTasksProvider);
    final habits = _ref.read(habitsControllerProvider);
    final nextPrayer = _ref.read(nextPrayerProvider);
    final stats = _ref.read(statsSnapshotProvider);

    return AiUserContext(
      userName: settings.userName,
      language: settings.language,
      mode: settings.aiMode,
      todayTasks: todayTasks.map((task) {
        return AiTaskContext(
          id: task.id,
          title: TaskLabels.title(l10n, task),
          category: task.category,
          priority: TaskLabels.priority(l10n, task.priority),
          isCompleted: task.isCompleted,
        );
      }).toList(),
      completedTasks: completedTasks.map((task) {
        return AiTaskContext(
          id: task.id,
          title: TaskLabels.title(l10n, task),
          category: task.category,
          priority: TaskLabels.priority(l10n, task.priority),
          isCompleted: true,
        );
      }).toList(),
      missedTasks: missedTasks.map((task) {
        return AiTaskContext(
          id: task.id,
          title: TaskLabels.title(l10n, task),
          category: task.category,
          priority: TaskLabels.priority(l10n, task.priority),
          isCompleted: false,
        );
      }).toList(),
      habits: habits.map((habit) {
        return AiHabitContext(
          id: habit.id,
          name: HabitLabels.name(l10n, habit),
          streak: habit.streak,
          progress: habit.progress,
          isCompletedToday: habit.isCompletedToday,
        );
      }).toList(),
      taskStreak: stats.taskStreak,
      habitStreak: stats.habitStreak,
      prayerStreak: stats.prayerStreak,
      appStreak: stats.appStreak,
      perfectDayStreak: stats.perfectDayStreak,
      nextPrayerName: PrayerLabels.name(l10n, nextPrayer.type),
      timeToPrayer: _formatDuration(nextPrayer.time.difference(DateTime.now())),
      weeklyCompletionRate: stats.completionRate,
    );
  }

  String _formatDuration(Duration duration) {
    final safeDuration = duration.isNegative ? Duration.zero : duration;
    final hours = safeDuration.inHours;
    final minutes = safeDuration.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }
}
