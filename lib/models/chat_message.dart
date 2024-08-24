class ChatMessage {
  final String message;
  final int senderId;
  final int receiverId;
  final DateTime timestamp;

  ChatMessage({
    required this.message,
    required this.senderId,
    required this.receiverId,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'message': message,
        'senderId': senderId,
        'receiverId': receiverId,
        'timestamp': timestamp.toIso8601String(),
      };

  static ChatMessage fromJson(Map<String, dynamic> json) => ChatMessage(
        message: json['message'],
        senderId: json['senderId'],
        receiverId: json['receiverId'],
        timestamp: DateTime.parse(json['timestamp']),
      );
}
