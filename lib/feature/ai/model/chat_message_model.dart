class ChatMessageModel {
  final String id;
  final String text;
  final bool isUser;
  final DateTime? timestamp;
  final bool isError;

  const ChatMessageModel({
    required this.id,
    required this.text,
    required this.isUser,
    this.timestamp,
    this.isError = false,
  });

  ChatMessageModel copyWith({
    String? id,
    String? text,
    bool? isUser,
    DateTime? timestamp,
    bool? isError,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      isError: isError ?? this.isError,
    );
  }
}
