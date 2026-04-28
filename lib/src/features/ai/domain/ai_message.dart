import '../../settings/domain/user_settings.dart';

enum AiMessageRole { user, assistant }

enum AiMessageStatus { sent, sending, failed }

class AiMessage {
  const AiMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.createdAt,
    this.status = AiMessageStatus.sent,
  });

  final String id;
  final AiMessageRole role;
  final String content;
  final DateTime createdAt;
  final AiMessageStatus status;

  AiMessage copyWith({
    String? id,
    AiMessageRole? role,
    String? content,
    DateTime? createdAt,
    AiMessageStatus? status,
  }) {
    return AiMessage(
      id: id ?? this.id,
      role: role ?? this.role,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }
}

class AiUserContext {
  const AiUserContext({
    required this.userName,
    required this.language,
    required this.mode,
    required this.todayTasks,
    required this.completedTasks,
    required this.missedTasks,
    required this.habits,
    required this.taskStreak,
    required this.habitStreak,
    required this.prayerStreak,
    required this.appStreak,
    required this.perfectDayStreak,
    required this.nextPrayerName,
    required this.timeToPrayer,
    required this.weeklyCompletionRate,
    this.mood,
  });

  final String userName;
  final AppLanguage language;
  final AiMentorMode mode;
  final List<AiTaskContext> todayTasks;
  final List<AiTaskContext> completedTasks;
  final List<AiTaskContext> missedTasks;
  final List<AiHabitContext> habits;
  final int taskStreak;
  final int habitStreak;
  final int prayerStreak;
  final int appStreak;
  final int perfectDayStreak;
  final String nextPrayerName;
  final String timeToPrayer;
  final double weeklyCompletionRate;
  final String? mood;

  int get openTasksCount => todayTasks.length - completedTasks.length;

  Map<String, Object?> toJson() {
    return {
      'user_name': userName,
      'language': language.name,
      'ai_mode': mode.name,
      'today_tasks': todayTasks.map((task) => task.toJson()).toList(),
      'completed_tasks': completedTasks.map((task) => task.toJson()).toList(),
      'missed_tasks': missedTasks.map((task) => task.toJson()).toList(),
      'habits': habits.map((habit) => habit.toJson()).toList(),
      'task_streak': taskStreak,
      'habit_streak': habitStreak,
      'prayer_streak': prayerStreak,
      'app_streak': appStreak,
      'perfect_day_streak': perfectDayStreak,
      'next_prayer_name': nextPrayerName,
      'time_to_prayer': timeToPrayer,
      'weekly_completion_rate': weeklyCompletionRate,
      'mood': mood,
    };
  }
}

class AiTaskContext {
  const AiTaskContext({
    required this.id,
    required this.title,
    required this.category,
    required this.priority,
    required this.isCompleted,
  });

  final String id;
  final String title;
  final String category;
  final String priority;
  final bool isCompleted;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'priority': priority,
      'is_completed': isCompleted,
    };
  }
}

class AiHabitContext {
  const AiHabitContext({
    required this.id,
    required this.name,
    required this.streak,
    required this.progress,
    required this.isCompletedToday,
  });

  final String id;
  final String name;
  final int streak;
  final double progress;
  final bool isCompletedToday;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'streak': streak,
      'progress': progress,
      'is_completed_today': isCompletedToday,
    };
  }
}
