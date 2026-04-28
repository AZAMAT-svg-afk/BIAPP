import 'ai_message.dart';
import 'ai_language_detector.dart';

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
    final detectedLanguage = AiLanguageDetector.detect(message);
    final userName = context.userName.trim().isEmpty
        ? detectedLanguage.neutralAddress
        : context.userName.trim();
    final normalizedMode = context.mode.name == 'off'
        ? 'normal'
        : context.mode.name;
    final languageRule =
        'CRITICAL RULE: The user is writing in ${detectedLanguage.promptName}. '
        'You MUST respond ONLY in ${detectedLanguage.promptName}. '
        'Never switch to any other language under any circumstances. '
        'Match the user language in every single response.';

    return {
      'message': message,
      'language': detectedLanguage.code,
      'detectedLanguage': detectedLanguage.promptName,
      'aiMode': normalizedMode,
      'modeSystemPrompt': _modeSystemPrompt(normalizedMode),
      'replyLanguageRule': languageRule,
      'userContext': {
        'name': userName,
        'detectedLanguage': detectedLanguage.promptName,
        'replyLanguageRule': languageRule,
        'aiMode': normalizedMode,
        'modeSystemPrompt': _modeSystemPrompt(normalizedMode),
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
      'history': history.map(_messageToJson).toList(),
    };
  }

  String _modeSystemPrompt(String mode) {
    return switch (mode) {
      'soft' =>
        'You are a very kind, gentle, supportive coach. Always encourage the user, use warm and motivating language. Never criticize. Celebrate small wins. Be like a caring friend who believes in the user.',
      'strict' =>
        'You are a strict, no-nonsense drill sergeant coach. Be direct and demanding. Call out excuses immediately. Push the user hard. Do not sugarcoat anything. Discipline and results are everything.',
      _ =>
        'You are a balanced productivity coach. Give honest but constructive feedback. Mix encouragement with accountability. Point out what needs improvement while staying respectful and motivating.',
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
