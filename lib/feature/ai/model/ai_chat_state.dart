import 'package:service_pro/feature/ai/model/chat_message_model.dart';

class AiChatState {
  final List<ChatMessageModel> messages;
  final bool isTyping;
  final List<String> quickPrompts;

  const AiChatState({
    required this.messages,
    this.isTyping = false,
    this.quickPrompts = const [
      "AC is not cooling properly",
      "Kitchen water pipe is leaking",
      "Power outage in bedroom circuit",
      "Need deep home cleaning",
      "Wall painting cost estimate",
    ],
  });

  AiChatState copyWith({
    List<ChatMessageModel>? messages,
    bool? isTyping,
    List<String>? quickPrompts,
  }) {
    return AiChatState(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
      quickPrompts: quickPrompts ?? this.quickPrompts,
    );
  }
}
