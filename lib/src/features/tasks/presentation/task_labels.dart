import '../../../../l10n/app_localizations.dart';
import '../domain/task_item.dart';

class TaskLabels {
  static String title(AppLocalizations l10n, TaskItem task) {
    return switch (task.seedKind) {
      SeedTaskKind.readQuran => l10n.taskReadQuranTitle,
      SeedTaskKind.pushups => l10n.taskPushupsTitle,
      SeedTaskKind.readBook => l10n.taskReadBookTitle,
      SeedTaskKind.english => l10n.habitEnglish,
      null => task.title,
    };
  }

  static String description(AppLocalizations l10n, TaskItem task) {
    return switch (task.seedKind) {
      SeedTaskKind.readQuran => l10n.taskReadQuranDesc,
      SeedTaskKind.pushups => l10n.taskPushupsDesc,
      SeedTaskKind.readBook => l10n.taskReadBookDesc,
      SeedTaskKind.english => l10n.habitEnglish,
      null => task.description,
    };
  }

  static String priority(AppLocalizations l10n, TaskPriority priority) {
    return switch (priority) {
      TaskPriority.low => l10n.priorityLow,
      TaskPriority.medium => l10n.priorityMedium,
      TaskPriority.high => l10n.priorityHigh,
    };
  }

  static String repeat(AppLocalizations l10n, RepeatType repeatType) {
    return switch (repeatType) {
      RepeatType.none => l10n.repeatNone,
      RepeatType.daily => l10n.repeatDaily,
      RepeatType.weekly => l10n.repeatWeekly,
      RepeatType.monthly => l10n.repeatMonthly,
    };
  }
}
