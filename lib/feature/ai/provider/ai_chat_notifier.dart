import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_pro/feature/ai/model/ai_chat_state.dart';
import 'package:service_pro/feature/ai/model/chat_message_model.dart';

class AiChatNotifier extends Notifier<AiChatState> {
  @override
  AiChatState build() {
    return AiChatState(
      messages: [
        ChatMessageModel(
          id: "welcome_1",
          text:
              "Hello! 👋 I'm your Service Pro AI Assistant.\n\nDescribe any issue at your home or office (e.g. AC cooling, plumbing leaks, electrical faults) and I'll recommend the right service & expert pro for you.",
          isUser: false,
          timestamp: DateTime.now(),
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

    // Simulate AI response delay
    await Future.delayed(const Duration(milliseconds: 900));

    final aiResponseText = _generateAiResponse(trimmed);

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
  }

  void clearChat() {
    state = build();
  }

  String _generateAiResponse(String input) {
    final lower = input.toLowerCase();

    if (lower.contains("ac") ||
        lower.contains("cool") ||
        lower.contains("air condition") ||
        lower.contains("compressor") ||
        lower.contains("filter")) {
      return "❄️ **AC Inspection & Servicing**\n\nCommon causes for poor cooling include low refrigerant gas, clogged dust filters, or a faulty compressor.\n\n• **Recommended Service:** Master AC Tune-Up\n• **Estimated Cost:** \$30 - \$50\n• **Estimated Duration:** 1 - 2 hours\n• **Recommended Pro:** Certified HVAC Technician";
    }

    if (lower.contains("pipe") ||
        lower.contains("water") ||
        lower.contains("leak") ||
        lower.contains("plumb") ||
        lower.contains("tap") ||
        lower.contains("sink") ||
        lower.contains("drain")) {
      return "🚰 **Plumbing Repair Service**\n\nWater leakage can damage walls and flooring. If the leak is active, please turn off the nearest stopcock valve.\n\n• **Recommended Service:** Pipe Leak Detection & Repair\n• **Estimated Cost:** \$25 - \$45\n• **Estimated Duration:** 45 - 90 minutes\n• **Recommended Pro:** Expert Licensed Plumber";
    }

    if (lower.contains("electric") ||
        lower.contains("light") ||
        lower.contains("switch") ||
        lower.contains("breaker") ||
        lower.contains("wire") ||
        lower.contains("power") ||
        lower.contains("voltage") ||
        lower.contains("circuit")) {
      return "⚡ **Electrical Diagnostic & Repair**\n\nTripping breakers or sparking switches indicate overloaded circuits or short wiring. Avoid touching exposed sockets.\n\n• **Recommended Service:** Circuit Diagnostic & Switch Fix\n• **Estimated Cost:** \$25 - \$40\n• **Estimated Duration:** 1 hour\n• **Recommended Pro:** Certified Electrician";
    }

    if (lower.contains("clean") ||
        lower.contains("dust") ||
        lower.contains("wash") ||
        lower.contains("maid") ||
        lower.contains("sofa") ||
        lower.contains("carpet")) {
      return "🧹 **Deep Home Cleaning**\n\nComplete sanitation including floor scrubbing, kitchen degreasing, bathroom disinfection, and furniture vacuuming.\n\n• **Recommended Service:** Premium Deep Cleaning\n• **Estimated Cost:** \$60 - \$120\n• **Estimated Duration:** 3 - 5 hours\n• **Recommended Pro:** Professional Cleaning Crew";
    }

    if (lower.contains("paint") ||
        lower.contains("wall") ||
        lower.contains("color") ||
        lower.contains("damp")) {
      return "🎨 **Interior & Exterior Painting**\n\nOur specialists handle wall smoothing, crack repair, primer sealing, and premium emulsion coating.\n\n• **Recommended Service:** Wall Prep & Painting\n• **Estimated Cost:** Custom quote per sq ft\n• **Estimated Duration:** 1 - 3 days\n• **Recommended Pro:** Master Painter Team";
    }

    if (lower.contains("price") ||
        lower.contains("cost") ||
        lower.contains("fee") ||
        lower.contains("discount") ||
        lower.contains("offer")) {
      return "🏷️ **Transparent Pricing & Deals**\n\nAll diagnostic visits start at **\$15**. Plus, your account is eligible for **30% OFF** on your first service booking with code **FIRST30**!";
    }

    if (lower.contains("hi") ||
        lower.contains("hello") ||
        lower.contains("hey")) {
      return "Hello! How can I assist you with your home services today? Feel free to describe any problem or choose one of the quick suggestions below.";
    }

    return "Thank you for the details! Based on your request, I recommend booking a **Diagnostic Visit** from one of our verified pros.\n\nThey will perform an on-site evaluation and give you a guaranteed fixed quote before starting work.\n\n• **Inspection Fee:** \$15 (waived upon service confirmation)\n• **Availability:** Today within 2 hours";
  }
}

final aiChatNotifierProvider =
    NotifierProvider.autoDispose<AiChatNotifier, AiChatState>(
      AiChatNotifier.new,
    );
