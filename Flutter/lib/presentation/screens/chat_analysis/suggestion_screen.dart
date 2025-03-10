import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../features/chat_analysis/view_models/chat_analysis_view_model.dart';
import '../../common/widgets/glass_card.dart';
import '../../common/widgets/temperature_meter.dart';

class SuggestionScreen extends StatefulWidget {
  const SuggestionScreen({Key? key}) : super(key: key);

  @override
  State<SuggestionScreen> createState() => _SuggestionScreenState();
}

class _SuggestionScreenState extends State<SuggestionScreen> {
  int _selectedSuggestion = 0;
  double _temperature = 22.0;
  final TextEditingController _customMessageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ChatAnalysisViewModel>(context);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // 대화 추천 데이터 (실제로는 ViewModel에서 가져옴)
    final originalMessage = "바빠서 안 될 것 같아.";
    final suggestedMessages = [
      {
        'text': "이번 주는 일이 있어서 어려울 것 같아. 다음 주에는 어때?",
        'temperature': 25.0,
        'type': "대안 제시",
        'effect': "상대방 배려"
      },
      {
        'text': "지금 마감 업무가 있어서 시간이 안 될 것 같네. 미안해.",
        'temperature': 18.0,
        'type': "이유 설명",
        'effect': "이해 도모"
      },
      {
        'text': "일정이 너무 빡빡해서 오늘은 힘들 것 같아.",
        'temperature': 12.0,
        'type': "직접 설명",
        'effect': "명확한 상황 전달"
      }
    ];

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
                      '대화 추천',
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
                      // 상대방 스타일 정보
                      GlassCard(
                        padding: const EdgeInsets.all(12),
                        isHighlighted: true,
                        highlightColor: const Color(0xFF4A8CFF),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              margin: const EdgeInsets.only(right: 12, top: 2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF4A8CFF).withOpacity(0.2),
                              ),
                              child: const Icon(
                                Icons.info_outline,
                                color: Color(0xFF4A8CFF),
                                size: 20,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '상대방 대화 스타일 분석',
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      color: const Color(0xFF4A8CFF),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '상대방은 부드러운 어조를 사용하므로, 비슷한 어조로 답하는 것이 효과적입니다.',
                                    style: TextStyle(
                                      color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // 원래 대화
                      Text(
                        '원래 대화',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '"$originalMessage"',
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF4A8CFF),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '8°C (차가움)',
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // 대화 온도 조절
                      Text(
                        '대화 온도 조절',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      TemperatureMeter(
                        temperature: _temperature,
                        onChanged: (value) {
                          setState(() {
                            _temperature = value;
                          });
                        },
                      ),

                      const SizedBox(height: 24),

                      // 추천 대안
                      Text(
                        '추천 대안 (선택)',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      ...List.generate(suggestedMessages.length, (index) {
                        final suggestion = suggestedMessages[index];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedSuggestion = index;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: _selectedSuggestion == index
                                    ? const Color(0xFFFF3B5C)
                                    : Colors.transparent,
                                width: 2,
                              ),
                              color: _selectedSuggestion == index
                                  ? const Color(0xFFFF3B5C).withOpacity(0.1)
                                  : Colors.white.withOpacity(0.05),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
                                          color: _getTagColor(suggestion['type'] as String)
                                              .withOpacity(0.2),
                                        ),
                                        child: Text(
                                          suggestion['type'] as String,
                                          style: TextStyle(
                                            color: _getTagColor(suggestion['type'] as String),
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),

                                      IconButton(
                                        icon: const Icon(
                                          Icons.copy,
                                          size: 18,
                                          color: Colors.grey,
                                        ),
                                        onPressed: () {
                                          Clipboard.setData(ClipboardData(
                                              text: suggestion['text'] as String));
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('텍스트가 복사되었습니다.'),
                                              duration: Duration(seconds: 1),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 12),

                                  Text(
                                    '"${suggestion['text']}"',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                      16,
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: _getTemperatureColor(
                                                  suggestion['temperature'] as double),
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            '${suggestion['temperature']}°C',
                                            style: TextStyle(
                                              color: Colors.grey[400],
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),

                                      Text(
                                        '효과: ${suggestion['effect']}',
                                        style: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),

                      // 직접 작성
                      const SizedBox(height: 16),
                      Text(
                        '직접 작성',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextField(
                          controller: _customMessageController,
                          decoration: const InputDecoration(
                            hintText: '직접 메시지를 작성해보세요...',
                            hintStyle: TextStyle(color: Colors.grey),
                            contentPadding: EdgeInsets.all(16),
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(color: Colors.white),
                          maxLines: 3,
                          minLines: 3,
                        ),
                      ),

                      // 액션 버튼
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // 현재 선택된 메시지 복사
                                if (_selectedSuggestion < suggestedMessages.length) {
                                  Clipboard.setData(ClipboardData(
                                      text: suggestedMessages[_selectedSuggestion]['text'] as String));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('텍스트가 복사되었습니다.'),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.copy),
                              label: const Text('복사하기'),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.grey[800],
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                // 대화 적용 및 이전 화면으로 이동
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: const Color(0xFFFF3B5C),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text('적용하기'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
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

  Color _getTagColor(String type) {
    if (type.contains('대안')) {
      return const Color(0xFFFF3B5C);
    } else if (type.contains('이유')) {
      return const Color(0xFF39D98A);
    } else {
      return const Color(0xFF4A8CFF);
    }
  }

  Color _getTemperatureColor(double temp) {
    if (temp >= 20) return const Color(0xFFFF3B5C); // 따뜻함
    if (temp >= 15) return const Color(0xFF39D98A); // 중립
    return const Color(0xFF4A8CFF); // 차가움
  }
}