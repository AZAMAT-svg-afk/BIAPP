class StreakSummary {
  const StreakSummary({
    required this.appStreak,
    required this.perfectDayStreak,
    required this.weeklyActivity,
  });

  final int appStreak;
  final int perfectDayStreak;
  final List<double> weeklyActivity;

  static const empty = StreakSummary(
    appStreak: 0,
    perfectDayStreak: 0,
    weeklyActivity: [0, 0, 0, 0, 0, 0, 0],
  );
}
