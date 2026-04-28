import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../settings/domain/user_settings.dart';

final activeMentorServiceProvider = Provider<ActiveMentorService>(
  (ref) => ActiveMentorService(),
);

final aiReminderPolicyProvider = Provider<AiReminderPolicy>(
  (ref) => const AiReminderPolicy(),
);

class ActiveMentorDecision {
  const ActiveMentorDecision({
    required this.shouldSend,
    required this.reason,
    required this.nextFollowUpCount,
  });

  final bool shouldSend;
  final String reason;
  final int nextFollowUpCount;
}

class ActiveMentorService {
  ActiveMentorService({AiReminderPolicy policy = const AiReminderPolicy()})
    : _policy = policy;

  final AiReminderPolicy _policy;

  ActiveMentorDecision evaluateIgnoredReminder({
    required ActiveMentorSettings settings,
    required DateTime now,
    required int alreadySentForItem,
  }) {
    return _policy.evaluate(
      settings: settings,
      now: now,
      alreadySentForItem: alreadySentForItem,
    );
  }
}

class AiReminderPolicy {
  const AiReminderPolicy();

  ActiveMentorDecision evaluate({
    required ActiveMentorSettings settings,
    required DateTime now,
    required int alreadySentForItem,
  }) {
    if (!settings.enabled || settings.mode == AiMentorMode.off) {
      return ActiveMentorDecision(
        shouldSend: false,
        reason: 'disabled',
        nextFollowUpCount: alreadySentForItem,
      );
    }

    if (alreadySentForItem >= settings.maxFollowUpsPerItem) {
      return ActiveMentorDecision(
        shouldSend: false,
        reason: 'limit_reached',
        nextFollowUpCount: alreadySentForItem,
      );
    }

    if (_isQuietHour(now, settings)) {
      return ActiveMentorDecision(
        shouldSend: false,
        reason: 'quiet_hours',
        nextFollowUpCount: alreadySentForItem,
      );
    }

    return ActiveMentorDecision(
      shouldSend: true,
      reason: 'allowed',
      nextFollowUpCount: alreadySentForItem + 1,
    );
  }

  bool _isQuietHour(DateTime now, ActiveMentorSettings settings) {
    final currentMinutes = now.hour * 60 + now.minute;
    final start =
        settings.quietHoursStart.hour * 60 + settings.quietHoursStart.minute;
    final end =
        settings.quietHoursEnd.hour * 60 + settings.quietHoursEnd.minute;

    if (start < end) {
      return currentMinutes >= start && currentMinutes < end;
    }
    return currentMinutes >= start || currentMinutes < end;
  }
}
