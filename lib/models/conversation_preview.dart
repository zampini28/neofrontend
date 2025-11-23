class ConversationPreview {
  final String patientId;
  final String patientName;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final String? photoUrl;

  ConversationPreview({
    required this.patientId,
    required this.patientName,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    this.photoUrl,
  });
}
