import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/providers/state/counseling_providers.dart';
import '../../../data/models/counselor_persona.dart';
import '../counseling/chat_screen.dart';
import 'package:intl/intl.dart';

// 상담 기록 프로바이더
final counselingHistoryProvider = StateProvider<List<ChatHistory>>((ref) => []);

// 마지막 채팅 시간 제공자
final lastChatTimeProvider = StateProvider.family<DateTime?, String>((ref, counselorId) {
  final chatHistory = ref.watch(counselingHistoryProvider);
  if (chatHistory.isEmpty) return null;
  
  final counselorChats = chatHistory.where((chat) => chat.counselorId == counselorId).toList();
  if (counselorChats.isEmpty) return null;
  
  return counselorChats.map((chat) => chat.timestamp).reduce((a, b) => a.isAfter(b) ? a : b);
});

// 채팅 기록 모델
class ChatHistory {
  final String counselorId;
  final DateTime timestamp;
  
  ChatHistory({required this.counselorId, required this.timestamp});
}

/// 상담 기록 화면
class ChatHistoryScreen extends ConsumerWidget {
  const ChatHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 정렬된 상담사 목록 사용
    final counselors = ref.watch(sortedCounselorsProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('상담 기록'),
        centerTitle: false,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navigateToNewCounseling(context),
            tooltip: '새 상담',
          ),
        ],
      ),
      body: counselors.isEmpty
          ? _buildEmptyState(context)
          : _buildHistoryList(context, ref, counselors),
    );
  }
  
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            '상담 기록이 없습니다',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            '상담사와 대화를 시작해보세요',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildHistoryList(BuildContext context, WidgetRef ref, List<CounselorPersona> counselors) {
    final theme = Theme.of(context);
    
    return ListView.builder(
      itemCount: counselors.length,
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      itemBuilder: (context, index) {
        final counselor = counselors[index];
        final lastChat = ref.watch(lastChatTimeProvider(counselor.id));
        
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 0, // 그림자 제거
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: theme.colorScheme.outline.withOpacity(0.1), // 매우 은은한 테두리
              width: 0.5,
            ),
          ),
          child: InkWell(
            onTap: () => _openChatWithCounselor(context, ref, counselor),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // 상담사 아바타
                      CircleAvatar(
                        backgroundColor: counselor.gradientColors[0],
                        child: Text(
                          counselor.avatarEmoji,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // 상담사 이름 및 마지막 채팅 시간
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              counselor.name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (lastChat != null)
                              Text(
                                _formatLastChatTime(lastChat),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.outline,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: theme.colorScheme.outline,
                      ),
                    ],
                  ),
                  if (counselor.description.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      counselor.description,
                      style: theme.textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (counselor.specialties.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    // 전문 분야 태그
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: counselor.specialties.map((specialty) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: theme.colorScheme.primary.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Text(
                            specialty,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  
  // 상담사와 채팅 시작
  void _openChatWithCounselor(BuildContext context, WidgetRef ref, CounselorPersona counselor) {
    // 채팅 메시지 초기화
    final chatMessages = ref.read(chatMessagesProvider(counselor.id).notifier);
    chatMessages.setInitialMessage(counselor);
    
    // 채팅 화면으로 이동
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          counselor: counselor,
        ),
      ),
    );
  }
  
  // 마지막 채팅 시간 포맷팅
  String _formatLastChatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inDays > 7) {
      return DateFormat('yyyy년 MM월 dd일').format(time);
    } else if (difference.inDays > 0) {
      return '${difference.inDays}일 전';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}시간 전';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}분 전';
    } else {
      return '방금 전';
    }
  }

  void _navigateToNewCounseling(BuildContext context) {
    Navigator.of(context).pushNamed('/counseling');
  }
} 