import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../features/chat_analysis/view_models/chat_analysis_view_model.dart';
import '../../common/widgets/glass_card.dart';
import '../../common/widgets/custom_nav_bar.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  // int _currentNavIndex = 0; // 대화 분석 화면이 기본 선택됨

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ChatAnalysisViewModel>(context);
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
                children: [
                  // 상단 앱바
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '대화 분석',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.1),
                          ),
                          child: Icon(
                            Icons.search,
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 검색창
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white.withOpacity(0.1),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: '대화 상대 또는 내용 검색...',
                          hintStyle: TextStyle(
                            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                            size: 18,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ),

                  // 대화 목록 제목
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '최근 분석 대화',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '총 ${viewModel.chatList.length}개',
                          style: TextStyle(
                            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 대화 목록
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: viewModel.chatList.length,
                      itemBuilder: (context, index) {
                        final chat = viewModel.chatList[index];
                        return GlassCard(
                          padding: const EdgeInsets.all(12),
                          child: InkWell(
                            onTap: () {
                              // 대화 상세 화면으로 이동
                            },
                            child: Row(
                              children: [
                                // 프로필 이미지
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [Color(0xFFFF3B5C), Color(0xFFB9375E)],
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      chat.name[0],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 12),

                                // 대화 정보
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // 이름 및 시간
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            chat.name,
                                            style: theme.textTheme.titleSmall?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            chat.lastAnalyzed,
                                            style: TextStyle(
                                              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),

                                      // 마지막 메시지
                                      Padding(
                                        padding: const EdgeInsets.only(top: 2, bottom: 4),
                                        child: Text(
                                          chat.lastMessage,
                                          style: TextStyle(
                                            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),

                                      // 태그 및 정보
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(30),
                                                  color: Colors.white.withOpacity(0.1),
                                                ),
                                                child: Text(
                                                  chat.relationship,
                                                  style: TextStyle(
                                                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                '${chat.messageCount}개',
                                                style: TextStyle(
                                                  color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),

                                          // 온도 표시
                                          Row(
                                            children: [
                                              Container(
                                                width: 6,
                                                height: 6,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: _getTemperatureColor(chat.temperature),
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                '${chat.temperature}°C',
                                                style: TextStyle(
                                                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
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

            // 플로팅 액션 버튼
            Positioned(
              bottom: 16,
              right: 16,
              child: Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFFFF3B5C), Color(0xFFB9375E)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFFF3B5C),
                      blurRadius: 10,
                      spreadRadius: -5,
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () {
                    // 새 대화 분석 시작
                  },
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
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
      ), */
    );
  }

  Color _getTemperatureColor(double temp) {
    if (temp >= 20) return const Color(0xFFFF3B5C); // 따뜻함
    if (temp >= 15) return const Color(0xFF39D98A); // 중립
    return const Color(0xFF4A8CFF); // 차가움
  }
}