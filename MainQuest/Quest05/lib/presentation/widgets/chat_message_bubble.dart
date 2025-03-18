import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/message.dart';
import '../../data/models/chat_message.dart' as chat;
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/typing_indicator.dart';

class ChatMessageBubble extends StatelessWidget {
  final dynamic message;
  final bool isLastMessage;
  final bool isTyping;
  
  const ChatMessageBubble({
    Key? key,
    required this.message,
    this.isLastMessage = false,
    this.isTyping = false,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // 메시지 타입에 따라 적절하게 처리
    final bool isUserMessage = _isUserMessage(message);
    final bool isSystemMessage = _isSystemMessage(message);
    final bool isFirstMessage = _getIsFirstMessage(message);
    final String messageText = _getMessageText(message);
    final String? senderName = _getSenderName(message);
    final DateTime? timestamp = _getTimestamp(message);
    final bool isMarkdown = _isMarkdown(message);
    
    // 시스템 메시지 처리 (시스템 안내, 초기 메시지 등)
    if (isSystemMessage) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant.withOpacity(0.7),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.1),
            width: 0.5,
          ),
        ),
        child: Text(
          messageText,
          style: TextStyle(
            fontSize: 14,
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }
    
    // 타이핑 인디케이터 상태인 경우
    if (isTyping) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(
            left: 16.0,
            right: 60.0,
            bottom: 8.0,
            top: 2.0,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withOpacity(0.6),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: _TypingIndicator(color: theme.colorScheme.primary),
        ),
      );
    }
    
    // 일반 메시지 처리
    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Card(
          color: Colors.transparent,
          elevation: 0,
          margin: EdgeInsets.only(
            // 메시지 간격 조정
            left: isUserMessage ? 60.0 : 16.0,
            right: isUserMessage ? 16.0 : 60.0,
            bottom: 8.0,
            top: 2.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: isUserMessage 
                  ? theme.colorScheme.primary
                  : theme.colorScheme.primaryContainer.withOpacity(0.7),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: EdgeInsets.all(12),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 첫 번째 메시지에서 상담사 이름 표시
                    if (!isUserMessage && isFirstMessage && senderName != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          senderName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: isUserMessage 
                                ? theme.colorScheme.onPrimary 
                                : theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    
                    // 메시지 텍스트
                    if (isMarkdown)
                      MarkdownBody(
                        data: messageText,
                        selectable: true,
                        styleSheet: MarkdownStyleSheet(
                          p: TextStyle(
                            fontSize: 15,
                            height: 1.4,
                            color: isUserMessage 
                                ? theme.colorScheme.onPrimary 
                                : theme.colorScheme.onSurface,
                          ),
                          h1: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isUserMessage 
                                ? theme.colorScheme.onPrimary 
                                : theme.colorScheme.onSurface,
                          ),
                          h2: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isUserMessage 
                                ? theme.colorScheme.onPrimary 
                                : theme.colorScheme.onSurface,
                          ),
                          h3: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isUserMessage 
                                ? theme.colorScheme.onPrimary 
                                : theme.colorScheme.onSurface,
                          ),
                          listBullet: TextStyle(
                            fontSize: 15,
                            color: isUserMessage 
                                ? theme.colorScheme.onPrimary 
                                : theme.colorScheme.onSurface,
                          ),
                          code: TextStyle(
                            backgroundColor: isUserMessage 
                                ? theme.colorScheme.primary.withOpacity(0.7) 
                                : theme.colorScheme.primary.withOpacity(0.1),
                            color: isUserMessage 
                                ? theme.colorScheme.onPrimary 
                                : theme.colorScheme.onSurface,
                          ),
                          codeblockDecoration: BoxDecoration(
                            color: isUserMessage 
                                ? theme.colorScheme.primary.withOpacity(0.7) 
                                : theme.colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      )
                    else
                      SelectableText(
                        messageText,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.4,
                          color: isUserMessage 
                              ? theme.colorScheme.onPrimary 
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                    
                    // 시간 표시 스페이서
                    SizedBox(height: 4),
                    
                    // 시간 표시
                    if (timestamp != null)
                      Align(
                        alignment: isUserMessage ? Alignment.bottomRight : Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            _formatTime(timestamp),
                            style: TextStyle(
                              fontSize: 11,
                              color: isUserMessage 
                                  ? theme.colorScheme.onPrimary.withOpacity(0.7)
                                  : theme.colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildAvatar(BuildContext context) {
    final theme = Theme.of(context);
    final bool isUserMessage = message is Message 
        ? message.sender == MessageSender.user 
        : message.sender == chat.MessageSender.user;
    
    // 사용자 메시지는 작은 원으로 표시
    if (isUserMessage) {
      return Container(
        width: 16,
        height: 16,
        margin: const EdgeInsets.only(left: 8, bottom: 8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: theme.colorScheme.primary.withOpacity(0.5),
        ),
      );
    }
    
    // 상담사 메시지는 큰 아바타로 표시 (실제로는 구현 필요)
    return Container(
      width: 36,
      height: 36,
      margin: const EdgeInsets.only(right: 8, bottom: 4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withOpacity(0.7),
            theme.colorScheme.primary.withOpacity(0.4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(
          '🤖', // 상담사 이모티콘
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
  
  Widget _buildMessageContent(BuildContext context, bool isUser) {
    final theme = Theme.of(context);
    
    // 마크다운으로 메시지 렌더링
    return MarkdownBody(
      data: message.content,
      styleSheet: MarkdownStyleSheet(
        p: TextStyle(
          color: isUser ? Colors.white : theme.textTheme.bodyLarge?.color,
          fontSize: 15,
          height: 1.4,
        ),
        h1: TextStyle(
          color: isUser ? Colors.white : theme.textTheme.titleLarge?.color,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        h2: TextStyle(
          color: isUser ? Colors.white : theme.textTheme.titleMedium?.color,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        h3: TextStyle(
          color: isUser ? Colors.white : theme.textTheme.titleSmall?.color,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
        listBullet: TextStyle(
          color: isUser ? Colors.white : theme.textTheme.bodyMedium?.color,
          fontSize: 15,
        ),
        strong: TextStyle(
          color: isUser ? Colors.white : theme.textTheme.bodyLarge?.color,
          fontWeight: FontWeight.bold,
        ),
        em: TextStyle(
          color: isUser ? Colors.white : theme.textTheme.bodyLarge?.color,
          fontStyle: FontStyle.italic,
        ),
        blockquote: TextStyle(
          color: isUser ? Colors.white.withOpacity(0.9) : theme.textTheme.bodyMedium?.color?.withOpacity(0.9),
          fontSize: 15,
          fontStyle: FontStyle.italic,
        ),
        code: TextStyle(
          color: isUser ? Colors.white : theme.textTheme.bodyLarge?.color,
          backgroundColor: isUser ? Colors.white.withOpacity(0.2) : theme.colorScheme.surfaceVariant.withOpacity(0.5),
          fontSize: 14,
          fontFamily: 'monospace',
        ),
        codeblockPadding: const EdgeInsets.all(8),
        codeblockDecoration: BoxDecoration(
          color: isUser 
              ? Colors.white.withOpacity(0.15) 
              : theme.colorScheme.surfaceVariant.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        horizontalRuleDecoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              width: 1,
              color: isUser ? Colors.white.withOpacity(0.4) : theme.dividerTheme.color ?? Colors.grey.withOpacity(0.3),
            ),
          ),
        ),
      ),
      onTapLink: (text, href, title) {
        if (href != null) {
          _launchURL(href);
        }
      },
    );
  }
  
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inSeconds < 60) {
      return '${diff.inSeconds}초 전';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}분 전';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}시간 전';
    } else {
      return '${diff.inDays}일 전';
    }
  }

  // 메시지 유형에 따라 사용자 메시지 여부 확인
  bool _isUserMessage(dynamic message) {
    if (message is Message) {
      return message.sender == MessageSender.user;
    } else if (message is chat.ChatMessage) {
      return message.sender == chat.MessageSender.user;
    }
    // 기본값
    return false;
  }
  
  // 시스템 메시지 여부 확인
  bool _isSystemMessage(dynamic message) {
    if (message is Message) {
      return message.isSystem;
    } else if (message is chat.ChatMessage) {
      return message.isSystem;
    }
    // 기본값
    return false;
  }
  
  // 첫 메시지 여부 확인
  bool _getIsFirstMessage(dynamic message) {
    if (message is Message) {
      // 메시지 모델에 해당 필드가 없으면 false
      return false;
    } else if (message is chat.ChatMessage) {
      // 타입에 따라 적절한 속성 반환
      return false; // 속성이 없는 경우 기본값
    }
    // 기본값
    return false;
  }
  
  // 메시지 텍스트 가져오기
  String _getMessageText(dynamic message) {
    if (message is Message) {
      return message.content;
    } else if (message is chat.ChatMessage) {
      return message.content;
    }
    // 기본값
    return "메시지를 불러올 수 없습니다.";
  }
  
  // 발신자 이름 가져오기
  String? _getSenderName(dynamic message) {
    if (message is Message) {
      // Message 타입에선 발신자 이름이 없음
      return null;
    } else if (message is chat.ChatMessage) {
      // ChatMessage 타입에선 발신자 이름 필드가 있을 수 있음
      return null; // 속성이 없는 경우
    }
    // 기본값
    return null;
  }
  
  // 시간 정보 가져오기
  DateTime? _getTimestamp(dynamic message) {
    if (message is Message) {
      return message.timestamp;
    } else if (message is chat.ChatMessage) {
      return message.timestamp;
    }
    // 기본값
    return null;
  }
  
  // 마크다운 형식인지 확인
  bool _isMarkdown(dynamic message) {
    // Message/ChatMessage 타입에 isMarkdown 필드가 없으므로 기본적으로 false 반환
    return false;
  }
}

// 애니메이션 타이핑 인디케이터 위젯
class _TypingIndicator extends StatefulWidget {
  final Color color;
  
  const _TypingIndicator({
    Key? key,
    required this.color,
  }) : super(key: key);

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator> with TickerProviderStateMixin {
  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _animations;
  
  @override
  void initState() {
    super.initState();
    
    _animationControllers = List.generate(
      3,
      (index) => AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 500),
      )..repeat(reverse: true),
    );
    
    // 각 점의 애니메이션 시작 시간을 다르게 설정
    Future.delayed(Duration(milliseconds: 150), () {
      _animationControllers[1].repeat(reverse: true);
    });
    
    Future.delayed(Duration(milliseconds: 300), () {
      _animationControllers[2].repeat(reverse: true);
    });
    
    _animations = _animationControllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeInOut,
        ),
      );
    }).toList();
  }
  
  @override
  void dispose() {
    for (final controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: AnimatedBuilder(
            animation: _animations[index],
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, -3 * _animations[index].value),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: widget.color.withOpacity(1.0 - (index * 0.2)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
} 