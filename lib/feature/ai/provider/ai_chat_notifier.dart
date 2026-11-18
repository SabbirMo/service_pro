import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_pro/feature/ai/model/ai_chat_state.dart';
import 'package:service_pro/feature/ai/model/chat_message_model.dart';
import 'package:service_pro/feature/ai/repository/ai_repository.dart';

class AiChatNotifier extends Notifier<AiChatState> {
  AiRepository get _repository => ref.read(aiRepositoryProvider);

  @override
  AiChatState build() {
    return const AiChatState(
      messages: [
        ChatMessageModel(
          id: "welcome_1",
          text: "Hello! 👋 How can I assist you with our services today?",
          isUser: false,
          timestamp: null,
        ),
      ],
    );
  }

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final userMessage = ChatMessageModel(
      id: "u_${DateTime.now().millisecondsSinceEpoch}",
      text: trimmed,
      isUser: true,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isTyping: true,
    );

    try {
      final aiResponseText = await _repository.sendChatMessage(trimmed);

      final aiMessage = ChatMessageModel(
        id: "ai_${DateTime.now().millisecondsSinceEpoch}",
        text: aiResponseText,
        isUser: false,
        timestamp: DateTime.now(),
      );

      state = state.copyWith(
        messages: [...state.messages, aiMessage],
        isTyping: false,
      );
    } catch (e) {
      final errorMessage = ChatMessageModel(
        id: "err_${DateTime.now().millisecondsSinceEpoch}",
        text: e.toString().replaceFirst('Exception: ', ''),
        isUser: false,
        timestamp: DateTime.now(),
        isError: true,
      );

      state = state.copyWith(
        messages: [...state.messages, errorMessage],
        isTyping: false,
      );
    }
  }
}

final aiChatNotifierProvider = NotifierProvider<AiChatNotifier, AiChatState>(
  AiChatNotifier.new,
);
