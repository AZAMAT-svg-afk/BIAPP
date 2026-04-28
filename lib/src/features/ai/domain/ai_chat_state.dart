import 'ai_message.dart';

class AiChatState {
  const AiChatState({
    required this.messages,
    required this.isSending,
    this.errorMessage,
  });

  final List<AiMessage> messages;
  final bool isSending;
  final String? errorMessage;

  static const empty = AiChatState(messages: [], isSending: false);

  AiChatState copyWith({
    List<AiMessage>? messages,
    bool? isSending,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AiChatState(
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
