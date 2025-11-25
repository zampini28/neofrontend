class ChatMessage {
  final String id;
  final String text;
  final String senderId;
  final DateTime timestamp;
  final bool isRead;

  ChatMessage({
    required this.id,
    required this.text,
    required this.senderId,
    required this.timestamp,
    this.isRead = false,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['messageId']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      text: json['text']?.toString() ?? '',
      senderId: json['senderId']?.toString() ?? '',
      timestamp: json['timestamp'] != null 
          ? DateTime.parse(json['timestamp'] as String) 
          : DateTime.now(),
      isRead: json['isRead'] as bool ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messageId': id,
      'text': text,
      'senderId': senderId,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
