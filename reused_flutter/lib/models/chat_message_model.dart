class ChatMessageModel {
  final String message;
  final int timestamp;
  final String senderName;
  final String senderId;
  ChatMessageModel({
    required this.message,
    required this.timestamp,
    required this.senderName,
    required this.senderId,
  });
}
