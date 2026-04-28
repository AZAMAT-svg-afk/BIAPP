import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../data/ai_service.dart';
import '../domain/ai_chat_state.dart';
import '../domain/ai_message.dart';
import '../domain/ai_service_models.dart';

final aiServiceProvider = Provider<AiService>((ref) {
  return ResilientAiService(primary: BackendAiService());
});

final aiControllerProvider = NotifierProvider<AiController, AiChatState>(
  AiController.new,
);

class AiController extends Notifier<AiChatState> {
  @override
  AiChatState build() {
    return AiChatState.empty;
  }

  Future<void> sendMessage({
    required String input,
    required AiUserContext context,
  }) async {
    final trimmed = input.trim();
    if (trimmed.isEmpty || state.isSending) {
      return;
    }

    final now = DateTime.now();
    final userMessage = AiMessage(
      id: const Uuid().v4(),
      role: AiMessageRole.user,
      content: trimmed,
      createdAt: now,
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isSending: true,
      clearError: true,
    );

    try {
      final response = await ref
          .read(aiServiceProvider)
          .sendMessage(
            AiChatRequest(
              message: trimmed,
              context: context,
              history: state.messages,
            ),
          );

      final assistantMessage = AiMessage(
        id: const Uuid().v4(),
        role: AiMessageRole.assistant,
        content: response.message,
        createdAt: DateTime.now(),
      );

      state = state.copyWith(
        messages: [...state.messages, assistantMessage],
        isSending: false,
        clearError: true,
      );
    } on Object {
      state = state.copyWith(
        messages: [
          for (final message in state.messages)
            if (message.id == userMessage.id)
              message.copyWith(status: AiMessageStatus.failed)
            else
              message,
        ],
        isSending: false,
        errorMessage: 'ai_unavailable',
      );
    }
  }

  void clear() {
    state = AiChatState.empty;
  }
}
