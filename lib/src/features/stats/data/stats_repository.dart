import '../../habits/domain/habit.dart';
import '../../prayer/domain/prayer_time.dart';
import '../../streak/domain/streak_summary.dart';
import '../../tasks/domain/task_item.dart';
import '../domain/stats_snapshot.dart';

class StatsRepository {
  StatsSnapshot buildSnapshot({
    required List<TaskItem> allTasks,
    required List<TaskItem> todayTasks,
    required List<TaskItem> missedTasks,
    required List<Habit> habits,
    required List<PrayerTimeItem> prayers,
    required StreakSummary streakSummary,
  }) {
    final completedTasks = todayTasks.where((task) => task.isCompleted).length;
    final completionRate = todayTasks.isEmpty
        ? 0.0
        : completedTasks / todayTasks.length;
    final completedHabits = habits.where((habit) {
      return habit.isCompletedToday;
    }).length;
    final stableHabit = habits.isEmpty
        ? null
        : habits.reduce((a, b) => a.streak >= b.streak ? a : b);
    final prayerCompleted = prayers
        .where((prayer) => prayer.type != PrayerType.sunrise)
        .where((prayer) => prayer.isCompleted)
        .length;
    final prayerTotal = prayers
        .where((prayer) => prayer.type != PrayerType.sunrise)
        .length;
    final habitStreak = stableHabit?.streak ?? 0;
    final currentPerfectDay =
        todayTasks.isNotEmpty &&
        completionRate >= 1 &&
        habits.every((habit) => habit.isCompletedToday) &&
        prayerCompleted >= prayerTotal &&
        prayerTotal > 0;

    return StatsSnapshot(
      todayTasksTotal: todayTasks.length,
      completedTasksToday: completedTasks,
      missedTasks: missedTasks.length,
      completionRate: completionRate,
      weeklyActivity: streakSummary.weeklyActivity,
      taskStreak: _calculateTaskStreak(allTasks),
      habitStreak: habitStreak,
      prayerStreak: prayerCompleted > 0 ? 6 : 5,
      appStreak: streakSummary.appStreak,
      perfectDayStreak: currentPerfectDay
          ? streakSummary.perfectDayStreak.clamp(1, 999)
          : streakSummary.perfectDayStreak,
      completedHabitsToday: completedHabits,
      totalHabits: habits.length,
      completedPrayersToday: prayerCompleted,
      totalPrayers: prayerTotal,
      bestWeekdayIndex: 4,
      stableHabit: stableHabit,
      mostMissedTask: missedTasks.isEmpty ? null : missedTasks.first,
    );
  }

  int _calculateTaskStreak(List<TaskItem> tasks) {
    final completedDates = {
      for (final task in tasks)
        if (task.isCompleted) _dateOnly(task.completedAt ?? task.updatedAt),
    };
    final today = _dateOnly(DateTime.now());
    var cursor = completedDates.contains(today)
        ? today
        : today.subtract(const Duration(days: 1));
    var streak = 0;
    while (completedDates.contains(cursor)) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  DateTime _dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }
}
