class ChatModel {
  final int id;
  final String name;
  final String relationship;
  final String lastMessage;
  final String lastAnalyzed;
  final int messageCount;
  final double temperature;

  ChatModel({
    required this.id,
    required this.name,
    required this.relationship,
    required this.lastMessage,
    required this.lastAnalyzed,
    required this.messageCount,
    required this.temperature,
  });

  // 객체를 맵으로 변환 (JSON 직렬화를 위해)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'relationship': relationship,
      'lastMessage': lastMessage,
      'lastAnalyzed': lastAnalyzed,
      'messageCount': messageCount,
      'temperature': temperature,
    };
  }

  // 맵에서 객체 생성 (JSON 역직렬화를 위해)
  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      id: map['id'],
      name: map['name'],
      relationship: map['relationship'],
      lastMessage: map['lastMessage'],
      lastAnalyzed: map['lastAnalyzed'],
      messageCount: map['messageCount'],
      temperature: map['temperature'],
    );
  }
}