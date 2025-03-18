// 채팅 메시지 모델 클래스
class ChatMessage {
  final String id;
  final String content;
  final MessageSender sender;
  final DateTime timestamp;
  final bool isTyping;
  final bool isError;
  final bool isSystem;
  
  const ChatMessage({
    required this.id,
    required this.content,
    required this.sender,
    required this.timestamp,
    this.isTyping = false,
    this.isError = false,
    this.isSystem = false,
  });
  
  // 메시지 시간 포맷 (HH:MM)
  String get formattedTime {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
  
  // JSON 직렬화
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'sender': sender == MessageSender.user ? 'user' : sender == MessageSender.ai ? 'ai' : 'system',
      'timestamp': timestamp.millisecondsSinceEpoch,
      'isTyping': isTyping,
      'isError': isError,
      'isSystem': isSystem,
    };
  }
  
  // JSON 역직렬화
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      content: json['content'],
      sender: json['sender'] == 'user' ? MessageSender.user : json['sender'] == 'ai' ? MessageSender.ai : MessageSender.system,
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
      isTyping: json['isTyping'] ?? false,
      isError: json['isError'] ?? false,
      isSystem: json['isSystem'] ?? false,
    );
  }
}

// 메시지 발신자 enum
enum MessageSender {
  user,
  ai,
  system,
} 