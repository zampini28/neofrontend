class ChatMessage {
  final String messageId;
  final String text;
  final String senderId;
  final DateTime timestamp;

  ChatMessage({
    required this.messageId,
    required this.text,
    required this.senderId,
    required this.timestamp,
  });
}
