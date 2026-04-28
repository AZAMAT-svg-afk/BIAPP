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
        'todayTasks': _safeList(rawContext['today_tasks']),
        'completedTasks': _safeList(rawContext['completed_tasks']),
        'missedTasks': _safeList(rawContext['missed_tasks']),
        'habits': _safeList(rawContext['habits']),
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
    };
  }

  List<Object?> _safeList(Object? value) {
    if (value is List) {
      return value.map(_jsonSafe).toList();
    }
    return const [];
  }

  Object? _jsonSafe(Object? value) {
    if (value == null || value is String || value is num || value is bool) {
      return value;
    }

    if (value is DateTime) {
      return value.toIso8601String();
    }

    if (value is List) {
      return value.map(_jsonSafe).toList();
    }

    if (value is Map) {
      return value.map(
        (key, mapValue) => MapEntry(key.toString(), _jsonSafe(mapValue)),
      );
    }

    return value.toString();
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
