import '../../habits/domain/habit.dart';
import '../../tasks/domain/task_item.dart';

class StatsSnapshot {
  const StatsSnapshot({
    required this.todayTasksTotal,
    required this.completedTasksToday,
    required this.missedTasks,
    required this.completionRate,
    required this.weeklyActivity,
    required this.taskStreak,
    required this.habitStreak,
    required this.prayerStreak,
    required this.appStreak,
    required this.perfectDayStreak,
    required this.completedHabitsToday,
    required this.totalHabits,
    required this.completedPrayersToday,
    required this.totalPrayers,
    required this.bestWeekdayIndex,
    this.stableHabit,
    this.mostMissedTask,
  });

  final int todayTasksTotal;
  final int completedTasksToday;
  final int missedTasks;
  final double completionRate;
  final List<double> weeklyActivity;
  final int taskStreak;
  final int habitStreak;
  final int prayerStreak;
  final int appStreak;
  final int perfectDayStreak;
  final int completedHabitsToday;
  final int totalHabits;
  final int completedPrayersToday;
  final int totalPrayers;
  final int bestWeekdayIndex;
  final Habit? stableHabit;
  final TaskItem? mostMissedTask;
}
