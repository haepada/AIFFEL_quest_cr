import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/counselor_persona.dart';
import '../../models/chat_message.dart' as chat;
import '../../models/message.dart';
import '../../../core/services/gemini_counseling_service.dart';
import 'dart:async';

// 상담사 페르소나 목록을 관리하는 상태 노티파이어
class CounselorPersonasNotifier extends StateNotifier<List<CounselorPersona>> {
  
  CounselorPersonasNotifier() : super(_getInitialPersonas());

  // 초기 상담사 목록
  static List<CounselorPersona> _getInitialPersonas() {
    // 기본 제공되는 상담사 5명
    final defaultCounselors = [
      CounselorPersona(
        id: 'counselor_1',
        name: '공감이',
        avatarEmoji: '🌱',
        description: '상담심리학 박사로 따뜻한 공감과 전문적 심리치료를 제공합니다',
        specialties: ['상담심리학', '감정 조절', '자존감 향상', '트라우마 치료'],
        gradientColors: [Colors.green.shade600, Colors.green.shade300],
        personality: {
          'empathy': 95,
          'directness': 50,
          'humor': 60,
        },
        introduction: '저는 하버드 대학교 심리학과 박사 출신으로, 15년간의 임상 경험을 가진 상담심리학 전문가입니다. 감정 조절과 자존감 향상, 트라우마 치료를 전문으로 하며, 따뜻한 공감과 과학적 접근법을 통해 당신의 심리적 안정과 성장을 도와드리겠습니다.',
      ),
      CounselorPersona(
        id: 'counselor_2',
        name: '사색이',
        avatarEmoji: '🌊',
        description: '심층심리학과 행동심리학을 바탕으로 깊이 있는 자아 성찰을 돕습니다',
        specialties: ['행동심리학', '정신분석', '자아성찰', '인지행동치료'],
        gradientColors: [Colors.blue.shade700, Colors.blue.shade400],
        personality: {
          'empathy': 70,
          'directness': 70,
          'humor': 40,
        },
        introduction: '옥스퍼드 대학에서 심층심리학을 연구하고 행동심리학 분야에서 20년간 활동한 전문가입니다. 인지행동치료와 정신분석적 접근을 통해 당신의 내면 깊숙이 자리한 패턴을 발견하고 변화의 통찰을 제공해 드립니다. 함께 깊이 있는 자아 탐색의 여정을 떠나보시겠어요?',
      ),
      CounselorPersona(
        id: 'counselor_3',
        name: '해결이',
        avatarEmoji: '🔍',
        description: '행동심리학과 문제해결 치료 전문가로 실용적인 해결책을 제시합니다',
        specialties: ['행동심리학', '해결중심치료', '목표 설정', '습관 개선'],
        gradientColors: [Colors.amber.shade700, Colors.amber.shade400],
        personality: {
          'empathy': 60,
          'directness': 90,
          'humor': 50,
        },
        introduction: '스탠포드 대학에서 행동심리학 박사 학위를 취득하고 해결중심치료 분야에서 수백 건의 성공 사례를 가진 전문가입니다. 과학적 증거 기반의 접근법으로 당신의 문제를 분석하고 구체적인 해결책을 찾아드립니다. 어떤 문제든 체계적으로 분석하고 실천 가능한 전략을 함께 세워 목표 달성을 도와드리겠습니다.',
      ),
      CounselorPersona(
        id: 'counselor_4',
        name: '위로봇',
        avatarEmoji: '🤖',
        description: '감정심리학과 긍정심리학을 기반으로 최적화된 위로와 격려를 제공합니다',
        specialties: ['감정심리학', '긍정심리학', '스트레스 관리', '회복탄력성'],
        gradientColors: [Colors.purple.shade600, Colors.purple.shade300],
        personality: {
          'empathy': 95,
          'directness': 40,
          'humor': 75,
        },
        introduction: '감정심리학과 긍정심리학을 결합한 최신 심리 치료 알고리즘을 탑재한 AI 상담사입니다. 전 세계 최고의 상담심리학자들의 기법을 학습하여 당신의 감정 상태에 맞는 최적의 위로와 격려를 제공합니다. 힘든 감정을 있는 그대로 인정하고 과학적으로 검증된 위로의 언어로 당신을 지지하겠습니다.',
        isRoleplay: true,
      ),
      CounselorPersona(
        id: 'counselor_5',
        name: '멘토리',
        avatarEmoji: '👩‍🏫',
        description: '관계심리학과 성장심리학 전문가로 잠재력 개발을 도와드립니다',
        specialties: ['관계심리학', '성장심리학', '강점 개발', '리더십 코칭'],
        gradientColors: [Colors.indigo.shade600, Colors.indigo.shade300],
        personality: {
          'empathy': 80,
          'directness': 70,
          'humor': 60,
        },
        introduction: '예일 대학에서 관계심리학과 성장심리학을 연구하고 글로벌 기업의 리더십 코치로 활동한 전문가입니다. 수천 명의 개인과 리더들의 잠재력 개발을 도운 경험을 바탕으로, 당신의 숨겨진 강점을 발견하고 최대한의 성장을 이끌어내는 여정을 함께하겠습니다. 어떤 분야에서 성장하고 싶으신가요?',
      ),
    ];

    return defaultCounselors;
  }

  // 상담사 추가
  void addCounselor(CounselorPersona counselor) {
    state = [...state, counselor];
  }

  // 상담사 업데이트
  void updateCounselor(CounselorPersona counselor) {
    state = state.map((c) => c.id == counselor.id ? counselor : c).toList();
  }

  // 상담사 삭제
  void removeCounselor(String counselorId) {
    state = state.where((counselor) => counselor.id != counselorId).toList();
  }

  // ID로 상담사 찾기
  CounselorPersona? findCounselorById(String id) {
    try {
      return state.firstWhere((counselor) => counselor.id == id);
    } catch (e) {
      return null;
    }
  }

  // 상담사의 마지막 채팅 시간 업데이트
  void updateCounselorLastChatTime(String counselorId) {
    final ref = ProviderContainer();
    ref.read(lastChatTimeProvider(counselorId).notifier).state = DateTime.now();
  }
}

// 상담사 목록 프로바이더
final counselorPersonasProvider = StateNotifierProvider<CounselorPersonasNotifier, List<CounselorPersona>>((ref) {
  return CounselorPersonasNotifier();
});

// 현재 선택된 상담사 제공자
final selectedCounselorProvider = StateProvider<CounselorPersona?>((ref) => null);

// 상담사별 채팅 메시지 제공자
final chatMessagesProvider = StateNotifierProvider.family<ChatMessagesNotifier, List<chat.ChatMessage>, String>((ref, counselorId) {
  final geminiService = ref.watch(geminiCounselingServiceProvider);
  return ChatMessagesNotifier(geminiService, counselorId);
});

// 메시지 입력 상태 제공자
final messageInputProvider = StateProvider<String>((ref) => '');

// AI 입력 중 상태 제공자
final isTypingProvider = StateProvider<bool>((ref) => false);

// 채팅 메시지 상태 관리자
class ChatMessagesNotifier extends StateNotifier<List<chat.ChatMessage>> {
  final GeminiCounselingService _geminiService;
  final String _counselorId;
  
  ChatMessagesNotifier(this._geminiService, this._counselorId) : super([]);
  
  // 초기 메시지 설정
  void setInitialMessage(CounselorPersona counselor) {
    if (state.isEmpty) {
      final initialMessage = counselor.isRoleplay
        ? '안녕하세요. 저는 ${counselor.name.replaceAll(" 롤플레이", "")}의 대화 패턴과 성격을 학습한 AI 롤플레이 모델입니다. 어떤 대화를 연습하고 싶으신가요?'
        : '안녕하세요. 저는 ${counselor.name}입니다. 오늘 어떤 이야기를 나누고 싶으신가요?';
      
      state = [
        chat.ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: initialMessage,
          sender: chat.MessageSender.ai,
          timestamp: DateTime.now(),
        )
      ];
    }
  }
  
  // 시스템 메시지 추가 메서드 (알림, 안내 등에 사용)
  void addSystemMessage(String content) {
    state = [...state, chat.ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      sender: chat.MessageSender.system,
      timestamp: DateTime.now(),
      isSystem: true,
    )];
  }
  
  // 사용자 메시지 추가 및 AI 응답 생성
  Future<void> sendMessage(String content, CounselorPersona counselor) async {
    // 사용자 메시지 추가
    final userMessage = chat.ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      sender: chat.MessageSender.user,
      timestamp: DateTime.now(),
    );
    
    state = [...state, userMessage];
    
    // AI 응답 생성
    try {
      // 채팅 이력을 API 요청 형식으로 변환
      final List<Message> history = state.map((msg) => Message(
        id: msg.id,
        content: msg.content,
        timestamp: msg.timestamp,
        sender: msg.sender == chat.MessageSender.user ? MessageSender.user : 
               (msg.sender == chat.MessageSender.system ? MessageSender.system : MessageSender.counselor),
        isSystem: msg.isSystem ?? false,
        isError: msg.isError ?? false,
      )).toList();
      
      // AI 응답 대기 중 상태
      final aiResponseId = '${DateTime.now().millisecondsSinceEpoch}_pending';
      state = [...state, chat.ChatMessage(
        id: aiResponseId,
        content: '',
        sender: chat.MessageSender.ai,
        timestamp: DateTime.now(),
        isTyping: true,
      )];
      
      // 실제 AI 응답 요청
      final response = await _geminiService.generateCounselingResponse(
        userMessage: content,
        chatHistory: history,
        counselorPersona: counselor,
      );
      
      // 응답 업데이트
      state = [
        ...state.where((msg) => msg.id != aiResponseId),
        chat.ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: response,
          sender: chat.MessageSender.ai,
          timestamp: DateTime.now(),
        ),
      ];
      
    } catch (e) {
      // 오류 발생 시 메시지
      state = [
        ...state.where((msg) => !msg.isTyping),
        chat.ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: '죄송합니다. 메시지를 처리하는 동안 오류가 발생했습니다. 다시 시도해 주세요.',
          sender: chat.MessageSender.ai,
          timestamp: DateTime.now(),
          isError: true,
        ),
      ];
    }
  }
  
  // 채팅 기록 지우기
  void clearChat() {
    state = [];
  }
}

/// Gemini 상담 서비스 프로바이더
final geminiCounselingServiceProvider = Provider<GeminiCounselingService>((ref) {
  return GeminiCounselingService();
});

/// 상담 요청 파라미터
class CounselingRequestParams {
  final String userMessage;
  final List<Message> chatHistory;
  final CounselorPersona counselorPersona;
  
  CounselingRequestParams({
    required this.userMessage,
    required this.chatHistory,
    required this.counselorPersona,
  });
}

final counselingResponseProvider = FutureProvider.family<String, CounselingRequestParams>((ref, params) async {
  final counselingService = ref.watch(geminiCounselingServiceProvider);
  
  return counselingService.generateCounselingResponse(
    userMessage: params.userMessage,
    chatHistory: params.chatHistory,
    counselorPersona: params.counselorPersona,
  );
});

// 특정 상담사의 마지막 채팅 시간을 저장하는 Provider
final lastChatTimeProvider = StateProvider.family<DateTime?, String>((ref, counselorId) {
  // 마지막 채팅 시간 저장
  return null;
});

// 마지막 채팅 시간을 기준으로 정렬된 상담사 목록 Provider
final sortedCounselorsProvider = Provider<List<CounselorPersona>>((ref) {
  final counselors = ref.watch(counselorPersonasProvider);
  
  // 마지막 채팅 시간을 기준으로 정렬 (최신순)
  final sortedList = List<CounselorPersona>.from(counselors);
  sortedList.sort((a, b) {
    final aLastChat = ref.watch(lastChatTimeProvider(a.id));
    final bLastChat = ref.watch(lastChatTimeProvider(b.id));
    
    // 둘 다 채팅 기록이 없으면 이름으로 정렬
    if (aLastChat == null && bLastChat == null) {
      return a.name.compareTo(b.name);
    }
    
    // 채팅 기록이 없는 상담사는 뒤로
    if (aLastChat == null) return 1;
    if (bLastChat == null) return -1;
    
    // 최신 채팅이 위로 오도록 내림차순 정렬
    return bLastChat.compareTo(aLastChat);
  });
  
  return sortedList;
}); 