import 'package:service_pro/feature/ai/model/chat_message_model.dart';

class AiChatState {
  final List<ChatMessageModel> messages;
  final bool isTyping;

  const AiChatState({
    required this.messages,
    this.isTyping = false,
  });

  AiChatState copyWith({
    List<ChatMessageModel>? messages,
    bool? isTyping,
  }) {
    return AiChatState(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
    );
  }
}
