import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../features/chat_analysis/view_models/chat_analysis_view_model.dart';
import '../../common/widgets/glass_card.dart';

class AnalysisResultScreen extends StatefulWidget {
  const AnalysisResultScreen({Key? key}) : super(key: key);

  @override
  State<AnalysisResultScreen> createState() => _AnalysisResultScreenState();
}

class _AnalysisResultScreenState extends State<AnalysisResultScreen> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ChatAnalysisViewModel>(context);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // 분석 결과 데이터 (실제로는 ViewModel에서 가져옴)
    final analysisResult = {
      'temperature': 15.5,
      'expressionStyles': {
        'logical': 65,
        'emotional': 15,
        'empathetic': 20,
        'direct': 70,
      },
      'patterns': [
        "직설적인 표현이 많아 상대방이 부담을 느낄 수 있습니다.",
        "상대방의 감정에 대한 공감 표현이 부족합니다.",
      ],
      'partnerPatterns': [
        "상대방은 감정 표현이 풍부한 편입니다.",
        "질문을 통해 의견을 묻는 경향이 있습니다.",
      ],
      'suggestions': [
        "상대방의 질문에 단답형으로 답하기보다 이유나 감정을 함께 표현해보세요.",
        "\"~해도 될까?\", \"~하면 어떨까?\" 등 부드러운 제안 형식을 활용해보세요.",
      ]
    };

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDarkMode
                ? [
              const Color(0xFF1E0338),
              const Color(0xFF1A1B3B),
              const Color(0xFF24162B),
            ]
                : [
              const Color(0xFFE8F0FD),
              const Color(0xFFF5F7FA),
              const Color(0xFFF9F0F8),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 앱바
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '분석 결과',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // 스크롤 가능한 내용
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 대화 온도 원형 표시
                      Center(
                        child: SizedBox(
                          width: 160,
                          height: 160,
                          child: Stack(
                            children: [
                              SizedBox(
                                width: 160,
                                height: 160,
                                child: CircularProgressIndicator(
                                  value: 0.5, // 50% 진행률 (온도에 따라 조정)
                                  strokeWidth: 8,
                                  backgroundColor: Colors.grey.withOpacity(0.1),
                                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF3B5C)),
                                ),
                              ),
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '대화 온도',
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      '${analysisResult['temperature']}°C',
                                      style: TextStyle(
                                        color: const Color(0xFFFF3B5C),
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '중립적인 대화',
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // 표현 스타일 분석 카드
                      GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '표현 스타일 분석',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),

                            _buildExpressionStyleBar(
                              '논리적 표현',
                              analysisResult['expressionStyles']['logical'],
                              const Color(0xFF4A8CFF),
                            ),
                            const SizedBox(height: 12),

                            _buildExpressionStyleBar(
                              '감정적 표현',
                              analysisResult['expressionStyles']['emotional'],
                              const Color(0xFF8E67D4),
                            ),
                            const SizedBox(height: 12),

                            _buildExpressionStyleBar(
                              '공감 표현',
                              analysisResult['expressionStyles']['empathetic'],
                              const Color(0xFF39D98A),
                            ),
                            const SizedBox(height: 12),

                            _buildExpressionStyleBar(
                              '직설적 표현',
                              analysisResult['expressionStyles']['direct'],
                              const Color(0xFFFF3B5C),
                            ),
                          ],
                        ),
                      ),

                      // 대화 패턴 분석 카드
                      GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '대화 패턴 분석',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),

                            Text(
                              '내 패턴',
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: Colors.grey[400],
                              ),
                            ),
                            const SizedBox(height: 8),

                            ...(analysisResult['patterns'] as List).map((pattern) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      margin: const EdgeInsets.only(top: 6, right: 8),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFFFF3B5C),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        pattern,
                                        style: TextStyle(
                                          color: Colors.grey[300],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),

                            const SizedBox(height: 16),

                            Text(
                              '상대방 패턴',
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: Colors.grey[400],
                              ),
                            ),
                            const SizedBox(height: 8),

                            ...(analysisResult['partnerPatterns'] as List).map((pattern) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      margin: const EdgeInsets.only(top: 6, right: 8),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFF4A8CFF),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        pattern,
                                        style: TextStyle(
                                          color: Colors.grey[300],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),

                      // 개선 제안 카드
                      GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '개선 제안',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),

                            ...(analysisResult['suggestions'] as List).asMap().entries.map((entry) {
                              final index = entry.key;
                              final suggestion = entry.value;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      margin: const EdgeInsets.only(right: 12),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: const LinearGradient(
                                          colors: [Color(0xFFFF3B5C), Color(0xFFB9375E)],
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${index + 1}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        suggestion,
                                        style: TextStyle(
                                          color: Colors.grey[300],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),

                      // 대화 추천 버튼
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: ElevatedButton(
                          onPressed: () {
                            // 대화 추천 화면으로 이동
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xFFFF3B5C),
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            '구체적인 대화 추천 받기',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpressionStyleBar(String label, int value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 14,
              ),
            ),
            Text(
              '$value%',
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 8,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 8,
                  color: Colors.grey.withOpacity(0.2),
                ),
                FractionallySizedBox(
                  widthFactor: value / 100,
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}