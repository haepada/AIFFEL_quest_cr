import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/services/gemini_counseling_service.dart' as gemini;
import '../../models/message.dart';
import '../../models/counselor_persona.dart';
import 'counseling_providers.dart';

/// 현재 채팅 메시지 목록을 관리하는 Provider
class ChatMessagesNotifier extends StateNotifier<List<Message>> {
  final gemini.GeminiCounselingService _counselingService;
  final Ref _ref;
  
  ChatMessagesNotifier(this._counselingService, this._ref) : super([]);
  
  /// 새 채팅 시작
  void startNewChat(CounselorPersona counselor) {
    state = [];
    
    // 상담사 소개 메시지 추가
    addSystemMessage(counselor.introduction.isNotEmpty 
      ? counselor.introduction 
      : '안녕하세요! 저는 ${counselor.name}입니다. 어떤 이야기든 편하게 나눠주세요.');
  }
  
  /// 사용자 메시지 추가 및 AI 응답 생성
  Future<void> sendMessage(String content, CounselorPersona counselor) async {
    if (content.trim().isEmpty) return;
    
    // 사용자 메시지 추가
    final userMessage = Message.fromUser(content: content);
    state = [...state, userMessage];
    
    // 로딩 표시 메시지 추가
    final loadingMessage = Message.fromSystem(
      content: '응답 생성 중...',
      isLoading: true,
    );
    state = [...state, loadingMessage];
    
    try {
      // AI 응답 생성 요청
      final response = await _counselingService.generateCounselingResponse(
        userMessage: content, 
        chatHistory: state.where((m) => !m.isLoading).toList(),
        counselorPersona: counselor,
      );
      
      // 로딩 메시지 제거
      state = state.where((message) => !message.isLoading).toList();
      
      // AI 응답 추가
      final aiMessage = Message.fromCounselor(content: response);
      state = [...state, aiMessage];
      
      // 상담사의 마지막 응답 시간 업데이트
      _ref.read(lastChatTimeProvider(counselor.id).notifier).state = DateTime.now();
    } catch (e) {
      // 오류 발생 시 에러 메시지로 대체
      state = state.where((message) => !message.isLoading).toList();
      final errorMessage = Message.error(
        content: '죄송합니다. 응답을 생성하는 중에 문제가 발생했습니다. 잠시 후 다시 시도해 주세요.',
      );
      state = [...state, errorMessage];
    }
  }
  
  /// 시스템 메시지 추가
  void addSystemMessage(String content) {
    final message = Message.fromSystem(content: content);
    state = [...state, message];
  }
  
  /// 메시지 삭제
  void deleteMessage(String messageId) {
    state = state.where((message) => message.id != messageId).toList();
  }
  
  /// 모든 메시지 삭제
  void clearMessages() {
    state = [];
  }
}

/// 채팅 메시지 목록 Provider
final chatMessagesProvider = StateNotifierProvider<ChatMessagesNotifier, List<Message>>((ref) {
  final counselingService = ref.watch(gemini.geminiCounselingServiceProvider);
  return ChatMessagesNotifier(counselingService, ref);
});

/// 현재 선택된 상담사 Provider
final selectedCounselorProvider = StateProvider<CounselorPersona?>((ref) => null);

/// 채팅 입력 Controller Provider
final chatTextControllerProvider = Provider<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(() => controller.dispose());
  return controller;
}); 