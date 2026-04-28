import '../../../../l10n/app_localizations.dart';
import '../domain/habit.dart';

class HabitLabels {
  static String name(AppLocalizations l10n, Habit habit) {
    return switch (habit.seedKind) {
      SeedHabitKind.quran => l10n.habitQuran,
      SeedHabitKind.book => l10n.habitBook,
      SeedHabitKind.pushups => l10n.habitPushups,
      SeedHabitKind.english => l10n.habitEnglish,
      SeedHabitKind.programming => l10n.habitProgramming,
      SeedHabitKind.water => l10n.habitWater,
      null => habit.name,
    };
  }
}
