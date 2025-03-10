class SuggestionModel {
  final String text;
  final double temperature;
  final String type;
  final String effect;

  SuggestionModel({
    required this.text,
    required this.temperature,
    required this.type,
    required this.effect,
  });

  // 객체를 맵으로 변환 (JSON 직렬화를 위해)
  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'temperature': temperature,
      'type': type,
      'effect': effect,
    };
  }

  // 맵에서 객체 생성 (JSON 역직렬화를 위해)
  factory SuggestionModel.fromMap(Map<String, dynamic> map) {
    return SuggestionModel(
      text: map['text'],
      temperature: map['temperature'],
      type: map['type'],
      effect: map['effect'],
    );
  }
}