class AnalysisResultModel {
  final double temperature;
  final Map<String, int> expressionStyles;
  final List<String> patterns;
  final List<String> partnerPatterns;
  final List<String> suggestions;

  AnalysisResultModel({
    required this.temperature,
    required this.expressionStyles,
    required this.patterns,
    required this.partnerPatterns,
    required this.suggestions,
  });

  // 객체를 맵으로 변환 (JSON 직렬화를 위해)
  Map<String, dynamic> toMap() {
    return {
      'temperature': temperature,
      'expressionStyles': expressionStyles,
      'patterns': patterns,
      'partnerPatterns': partnerPatterns,
      'suggestions': suggestions,
    };
  }

  // 맵에서 객체 생성 (JSON 역직렬화를 위해)
  factory AnalysisResultModel.fromMap(Map<String, dynamic> map) {
    return AnalysisResultModel(
      temperature: map['temperature'],
      expressionStyles: Map<String, int>.from(map['expressionStyles']),
      patterns: List<String>.from(map['patterns']),
      partnerPatterns: List<String>.from(map['partnerPatterns']),
      suggestions: List<String>.from(map['suggestions']),
    );
  }
}