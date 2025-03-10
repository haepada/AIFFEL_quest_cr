enum MessageSender {
  user,
  ai,
}

class MessageModel {
  final String text;
  final MessageSender sender;
  final DateTime timestamp;

  MessageModel({
    required this.text,
    required this.sender,
    required this.timestamp,
  });

  // 객체를 맵으로 변환 (JSON 직렬화를 위해)
  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'sender': sender.toString(),
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // 맵에서 객체 생성 (JSON 역직렬화를 위해)
  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      text: map['text'],
      sender: map['sender'] == 'MessageSender.user' ? MessageSender.user : MessageSender.ai,
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}