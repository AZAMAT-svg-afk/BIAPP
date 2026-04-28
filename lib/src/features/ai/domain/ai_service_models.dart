import 'ai_message.dart';

class AiChatRequest {
  const AiChatRequest({
    required this.message,
    required this.context,
    required this.history,
  });

  final String message;
  final AiUserContext context;
  final List<AiMessage> history;

  Map<String, Object?> toJson() {
    return {
      'message': message,
      'context': context.toJson(),
      'history': history.map(_messageToJson).toList(),
    };
  }

  Map<String, Object?> toBackendJson() {
    final rawContext = context.toJson();
    return {
      'message': message,
      'language': context.language.code,
      'aiMode': context.mode.name,
      'userContext': {
        'name': context.userName,
        'todayTasks': rawContext['today_tasks'],
        'completedTasks': rawContext['completed_tasks'],
        'missedTasks': rawContext['missed_tasks'],
        'habits': rawContext['habits'],
        'streaks': {
          'task': context.taskStreak,
          'habit': context.habitStreak,
          'prayer': context.prayerStreak,
          'app': context.appStreak,
          'perfectDay': context.perfectDayStreak,
        },
        'nextPrayer': {
          'name': context.nextPrayerName,
          'time': context.timeToPrayer,
        },
        'weeklyStats': {'completionRate': context.weeklyCompletionRate},
        'mood': context.mood,
      },
      'context': rawContext,
      'history': history.map(_messageToJson).toList(),
    };
  }

  Map<String, Object?> _messageToJson(AiMessage message) {
    return {
      'role': message.role.name,
      'content': message.content,
      'created_at': message.createdAt.toIso8601String(),
    };
  }
}

class AiChatResponse {
  const AiChatResponse({required this.message, this.provider = 'mock'});

  final String message;
  final String provider;
}
