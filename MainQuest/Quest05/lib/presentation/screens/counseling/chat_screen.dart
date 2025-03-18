import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui';
import '../../../data/models/counselor_persona.dart';
import '../../../data/models/message.dart';
import '../../../data/providers/state/counseling_providers.dart';
import '../../../app.dart';
import '../../widgets/typing_indicator.dart';
import '../../../core/services/gemini_counseling_service.dart';
import '../../widgets/chat_message_bubble.dart';
import 'persona_creation_screen.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final CounselorPersona counselor;
  
  const ChatScreen({
    Key? key,
    required this.counselor,
  }) : super(key: key);
  
  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  bool _isComposing = false;
  bool _isSending = false;
  bool _isScrolledToBottom = true;
  bool _showScrollToBottom = false;
  
  // UI 상태 변수
  bool get _canSend => _messageController.text.trim().isNotEmpty && !_isSending;

  @override
  void initState() {
    super.initState();
    
    // 스크롤 리스너 초기화
    _scrollController.addListener(_handleScroll);
    
    // 채팅 초기화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
    
    // 메시지 입력 컨트롤러 리스너
    _messageController.addListener(() {
      setState(() {
        _isComposing = _messageController.text.trim().isNotEmpty;
      });
    });
  }
  
  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    _messageController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
  
  // 스크롤 이벤트 처리
  void _handleScroll() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.offset;
      setState(() {
        _isScrolledToBottom = currentScroll >= (maxScroll - 100);
        _showScrollToBottom = !_isScrolledToBottom;
      });
    }
  }
  
  // 맨 아래로 스크롤
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }
  
  // 메시지 전송 처리
  void _handleSubmitted() {
    if (_messageController.text.trim().isEmpty || _isSending) {
      return;
    }
    
    final userMessage = _messageController.text.trim();
    _messageController.clear();
    setState(() {
      _isComposing = false;
      _isSending = true;
    });
    
    // 메시지 저장 및 AI 응답 요청
    final messagesNotifier = ref.read(chatMessagesProvider(widget.counselor.id).notifier);
    messagesNotifier.sendMessage(userMessage, widget.counselor).then((_) {
      setState(() {
        _isSending = false;
      });
      _scrollToBottom();
      
      // 입력 완료 알림 제거 - 시각적 피드백은 메시지 추가로 충분함
    });
  }

  @override
  Widget build(BuildContext context) {
    // 메시지 목록 변화 감지
    final messages = ref.watch(chatMessagesProvider(widget.counselor.id));
    final theme = Theme.of(context);
    
    // 메시지 변경 시 스크롤 조정
    if (_isScrolledToBottom && messages.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              widget.counselor.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (widget.counselor.isRoleplay)
              Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.orange.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: const Text(
                  '롤플레이',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ),
          ],
        ),
        centerTitle: false,
        backgroundColor: theme.colorScheme.surface,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: '뒤로 가기',
        ),
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              color: theme.colorScheme.surface.withOpacity(0.7),
            ),
          ),
        ),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: widget.counselor.gradientColors[0],
              child: Text(
                widget.counselor.avatarEmoji,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // 메뉴 표시
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => _buildOptionsMenu(context),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.background,
              ),
              // 채팅 메시지 리스트
              child: _buildChatList(messages),
            ),
          ),
          // 메시지 입력 영역
          _buildMessageInput(context),
        ],
      ),
      // 맨 아래로 스크롤 버튼
      floatingActionButton: _showScrollToBottom ? _buildScrollToBottomButton() : null,
    );
  }
  
  // 채팅 목록 UI
  Widget _buildChatList(List<dynamic> messages) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isLastMessage = index == messages.length - 1;
        
        return ChatMessageBubble(
          message: message,
          isLastMessage: isLastMessage,
          isTyping: message.isTyping ?? false,
        ).animate()
          .fadeIn(duration: 300.ms)
          .slideY(begin: 0.1, end: 0, duration: 300.ms, curve: Curves.easeOutQuad);
      },
    );
  }
  
  // 스크롤 하단 버튼 UI
  Widget _buildScrollToBottomButton() {
    return FloatingActionButton(
      mini: true,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      elevation: 2,
      onPressed: _scrollToBottom,
      child: Icon(
        Icons.arrow_downward,
        color: Theme.of(context).colorScheme.onPrimaryContainer,
        size: 20,
      ),
    ).animate().fade(duration: 200.ms);
  }
  
  // 메시지 입력 UI
  Widget _buildMessageInput(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 메시지 입력 텍스트 필드
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: theme.colorScheme.outline.withOpacity(0.3),
                    width: 1.0,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: TextField(
                    controller: _messageController,
                    focusNode: _focusNode,
                    textInputAction: TextInputAction.send,
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    minLines: 1,
                    style: TextStyle(fontSize: 16),
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: '메시지를 입력하세요...',
                      hintStyle: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, 
                        vertical: 10,
                      ),
                    ),
                    onSubmitted: (_) => _canSend ? _handleSubmitted() : null,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          
          // 전송 버튼
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            width: 48,
            height: 48,
            child: Material(
              color: _canSend 
                  ? theme.colorScheme.primary 
                  : theme.colorScheme.primary.withOpacity(0.3),
              borderRadius: BorderRadius.circular(24),
              child: InkWell(
                onTap: _canSend ? _handleSubmitted : null,
                borderRadius: BorderRadius.circular(24),
                child: _isSending
                    ? Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: CircularProgressIndicator(
                          color: theme.colorScheme.onPrimary,
                          strokeWidth: 2.0,
                        ),
                      )
                    : Icon(
                        Icons.send,
                        color: theme.colorScheme.onPrimary,
                        size: 22,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // 옵션 메뉴 UI
  Widget _buildOptionsMenu(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.9),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 드래그 핸들
                  Container(
                    height: 4,
                    width: 40,
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurface.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  
                  // 메뉴 리스트
                  ListTile(
                    leading: const Icon(Icons.delete_outline),
                    title: const Text('대화 기록 지우기'),
                    onTap: () {
                      // 대화 기록 삭제 로직
                      ref.read(chatMessagesProvider(widget.counselor.id).notifier).clearChat();
                      Navigator.pop(context);
                    },
                  ),
                  
                  // 상담사가 커스텀 상담사인 경우 편집 옵션 제공
                  if (widget.counselor.isCustom)
                    ListTile(
                      leading: const Icon(Icons.edit),
                      title: const Text('상담사 편집'),
                      onTap: () {
                        Navigator.pop(context);
                        // 편집 화면으로 이동
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PersonaCreationScreen(
                              editingCounselor: widget.counselor,
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 