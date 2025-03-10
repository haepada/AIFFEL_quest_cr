import 'package:flutter/material.dart';
import '../../common/widgets/glass_card.dart';
import '../../common/widgets/custom_nav_bar.dart';

class AISelectionScreen extends StatefulWidget {
  const AISelectionScreen({Key? key}) : super(key: key);

  @override
  State<AISelectionScreen> createState() => _AISelectionScreenState();
}

class _AISelectionScreenState extends State<AISelectionScreen> {
  //int _currentNavIndex = 2; // AI 상담 화면이 기본 선택됨

  // AI 페르소나 목록
  final List<Map<String, dynamic>> aiPersonas = [
    {
      'id': 'empathetic',
      'name': '서진아',
      'avatar': '👩',
      'gradient': [const Color(0xFFFF6AC2), const Color(0xFFA637AB)],
      'persona': '공감형',
      'description': '따뜻한 공감으로 이야기를 들어주는 친구',
      'style': '감정을 먼저 이해하고 공감하는 대화 스타일',
    },
    {
      'id': 'analytical',
      'name': '이성민',
      'avatar': '🧠',
      'gradient': [const Color(0xFF4A8CFF), const Color(0xFF2D6FE0)],
      'persona': '분석형',
      'description': '객관적인 시각으로 조언해주는 조언자',
      'style': '논리적이고 데이터 기반의 솔루션 제공',
    },
    {
      'id': 'practical',
      'name': '정현기',
      'avatar': '⚡',
      'gradient': [const Color(0xFF39D98A), const Color(0xFF27AA64)],
      'persona': '실용형',
      'description': '실제 적용 가능한 해결책을 알려주는 멘토',
      'style': '구체적이고 실천 가능한 조언 위주의 대화',
    },
    {
      'id': 'humorous',
      'name': '김해피',
      'avatar': '😊',
      'gradient': [const Color(0xFFFFB340), const Color(0xFFFF9800)],
      'persona': '유머형',
      'description': '유쾌한 대화로 긍정 에너지를 주는 버디',
      'style': '가볍고 친근한 대화와 긍정적 재해석',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

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
        child: Stack(
          children: [
            // 배경 효과
            Positioned(
              top: 100,
              right: -100,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF8E67D4).withOpacity(0.3),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.7],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 100,
              left: -100,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF4A8CFF).withOpacity(0.3),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.7],
                  ),
                ),
              ),
            ),

            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 앱바
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'AI 선택',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      '김온도님, 오늘은 어떤 대화가 필요하신가요?',
                      style: TextStyle(
                        color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                        fontSize: 16,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // AI 페르소나 목록
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: aiPersonas.length,
                      itemBuilder: (context, index) {
                        final ai = aiPersonas[index];
                        return GlassCard(
                          child: InkWell(
                            onTap: () {
                              // AI 상담 대화 화면으로 이동
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => AIConsultationScreen(
                                    aiPersona: ai,
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // AI 프로필 정보
                                Row(
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          colors: ai['gradient'],
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          ai['avatar'],
                                          style: const TextStyle(fontSize: 28),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          ai['name'],
                                          style: theme.textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          ai['persona'],
                                          style: TextStyle(
                                            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                // AI 설명
                                Text(
                                  ai['description'],
                                  style: TextStyle(
                                    color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                                    fontSize: 15,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                // AI 스타일
                                Text(
                                  ai['style'],
                                  style: TextStyle(
                                    color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      /*
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentNavIndex,
        onTap: (index) {
          setState(() {
            _currentNavIndex = index;
          });
          // 실제 앱에서는 여기서 페이지 이동 로직 구현
        },
      ),*/
    );
  }
}

class AIConsultationScreen extends StatefulWidget {
  final Map<String, dynamic> aiPersona;

  const AIConsultationScreen({
    Key? key,
    required this.aiPersona,
  }) : super(key: key);

  @override
  State<AIConsultationScreen> createState() => _AIConsultationScreenState();
}

class _AIConsultationScreenState extends State<AIConsultationScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();

    // 초기 AI 인사 메시지 추가
    _addMessage(
      '안녕하세요, 김온도님! ${widget.aiPersona['name']}입니다. 오늘은 어떤 대화를 나누고 싶으신가요?',
      'ai',
    );
  }

  void _addMessage(String text, String sender) {
    setState(() {
      _messages.add({
        'text': text,
        'sender': sender,
        'timestamp': DateTime.now(),
      });
    });
  }

  void _handleSendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final userMessage = _messageController.text;
    _addMessage(userMessage, 'user');
    _messageController.clear();

    // AI 응답 (실제로는 비동기로 처리)
    Future.delayed(const Duration(seconds: 1), () {
      String aiResponse = '';

      // 간단한 AI 응답 시뮬레이션
      if (userMessage.contains('안녕') || userMessage.contains('hi')) {
        aiResponse = '안녕하세요! 기분이 어떠신가요?';
      } else if (userMessage.contains('화가 나') || userMessage.contains('짜증')) {
        if (widget.aiPersona['id'] == 'empathetic') {
          aiResponse = '화가 나셨군요. 그런 감정을 느끼는 건 자연스러운 일이에요. 무슨 일이 있었는지 더 말씀해주실래요?';
        } else if (widget.aiPersona['id'] == 'analytical') {
          aiResponse = '화가 날 때는 감정을 객관적으로 관찰하는 것이 도움이 됩니다. 어떤 상황에서 화가 나셨나요?';
        } else if (widget.aiPersona['id'] == 'practical') {
          aiResponse = '화가 났을 때 도움이 되는 방법은 잠시 깊게 호흡하고, 상황에서 잠시 벗어나는 거예요. 산책을 하거나 물 한 잔 마시는 건 어떨까요?';
        } else {
          aiResponse = '화났을 때는 안 웃기는 유머가 오히려 더 웃길 때가 있죠! 잠시 긍정적인 것에 집중해보면 어떨까요? 😊';
        }
      } else if (userMessage.contains('조언') || userMessage.contains('도움')) {
        aiResponse = '어떤 종류의 조언이 필요하신가요? 좀 더 구체적으로 말씀해주시면 더 도움이 될 수 있을 것 같아요.';
      } else {
        aiResponse = '말씀해주셔서 감사합니다. 더 구체적인 이야기를 나눠볼까요?';
      }

      _addMessage(aiResponse, 'ai');
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

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
              // 채팅 헤더
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white.withOpacity(0.1),
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: widget.aiPersona['gradient'],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          widget.aiPersona['avatar'],
                          style: const TextStyle(fontSize: 22),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.aiPersona['name'],
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white.withOpacity(0.1),
                              ),
                              child: Text(
                                '"상담이"',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          widget.aiPersona['persona'],
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    InkWell(
                      onTap: () {
                        // 설정 메뉴 열기
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                        child: const Icon(
                          Icons.more_vert,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 메시지 영역
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    final isUser = message['sender'] == 'user';

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (!isUser) ...[
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: widget.aiPersona['gradient'],
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  widget.aiPersona['avatar'],
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],

                          Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.75,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: isUser
                                  ? const Color(0xFFFF3B5C).withOpacity(0.2)
                                  : Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(20).copyWith(
                                bottomLeft: isUser ? null : const Radius.circular(0),
                                bottomRight: isUser ? const Radius.circular(0) : null,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message['text'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _formatTime(message['timestamp']),
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 10,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ],
                            ),
                          ),

                          if (isUser) ...[
                            const SizedBox(width: 8),
                            Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [Color(0xFFFF3B5C), Color(0xFFB9375E)],
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  '나',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),

              // 입력 영역
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.white.withOpacity(0.1),
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                      ),
                      child: const Icon(
                        Icons.sentiment_satisfied_alt_outlined,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white.withOpacity(0.1),
                        ),
                        child: TextField(
                          controller: _messageController,
                          decoration: const InputDecoration(
                            hintText: '메시지를 입력하세요...',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(color: Colors.white),
                          onSubmitted: (_) => _handleSendMessage(),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFFFF3B5C), Color(0xFFB9375E)],
                        ),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 18,
                        ),
                        onPressed: _handleSendMessage,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}