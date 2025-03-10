import 'package:flutter/material.dart';
import '../models/ai_persona_model.dart';
import '../models/message_model.dart';

class AIConsultationViewModel extends ChangeNotifier {
  // AI 페르소나 목록
  final List<AIPersonaModel> _personas = [
    AIPersonaModel(
      id: 'empathetic',
      name: '서진아',
      avatar: '👩',
      gradient: const [Color(0xFFFF6AC2), Color(0xFFA637AB)],
      persona: '공감형',
      description: '따뜻한 공감으로 이야기를 들어주는 친구',
      style: '감정을 먼저 이해하고 공감하는 대화 스타일',
      defaultNickname: '공감이',
      initialGreeting: '안녕하세요! 오늘 어떤 이야기를 나누고 싶으신가요? 어떤 감정이든 편하게 말씀해주세요.',
    ),
    AIPersonaModel(
      id: 'analytical',
      name: '이성민',
      avatar: '🧠',
      gradient: const [Color(0xFF4A8CFF), Color(0xFF2D6FE0)],
      persona: '분석형',
      description: '객관적인 시각으로 조언해주는 조언자',
      style: '논리적이고 데이터 기반의 솔루션 제공',
      defaultNickname: '분석이',
      initialGreeting: '안녕하세요. 어떤 상황을 분석해드릴까요? 객관적인 관점에서 도움을 드리겠습니다.',
    ),
    AIPersonaModel(
      id: 'practical',
      name: '정현기',
      avatar: '⚡',
      gradient: const [Color(0xFF39D98A), Color(0xFF27AA64)],
      persona: '실용형',
      description: '실제 적용 가능한 해결책을 알려주는 멘토',
      style: '구체적이고 실천 가능한 조언 위주의 대화',
      defaultNickname: '실전이',
      initialGreeting: '안녕하세요! 어떤 문제를 해결하고 싶으신가요? 실질적인 방법을 함께 찾아보겠습니다.',
    ),
    AIPersonaModel(
      id: 'humorous',
      name: '김해피',
      avatar: '😊',
      gradient: const [Color(0xFFFFB340), Color(0xFFFF9800)],
      persona: '유머형',
      description: '유쾌한 대화로 긍정 에너지를 주는 버디',
      style: '가볍고 친근한 대화와 긍정적 재해석',
      defaultNickname: '웃음이',
      initialGreeting: '안녕~ 오늘 기분은 어때요? 뭐든 편하게 이야기해요. 함께 웃으면서 대화해봐요! 😄',
    ),
  ];

  List<AIPersonaModel> get personas => _personas;

  // 선택된 AI 페르소나
  AIPersonaModel? _selectedPersona;
  AIPersonaModel? get selectedPersona => _selectedPersona;

  // 현재 호칭
  String? _currentNickname;
  String? get currentNickname => _currentNickname;

  // 말투 설정 (친근한/격식 있는)
  String _formality = 'casual';  // 'casual' or 'formal'
  String get formality => _formality;

  // 대화 기록
  final List<MessageModel> _messages = [];
  List<MessageModel> get messages => _messages;

  // 메시지 전송 중 상태
  bool _isTyping = false;
  bool get isTyping => _isTyping;

  // AI 선택 메서드
  void selectPersona(AIPersonaModel persona) {
    _selectedPersona = persona;
    _currentNickname = persona.defaultNickname;
    _messages.clear();

    // 초기 인사 메시지 추가
    _messages.add(MessageModel(
      text: persona.initialGreeting,
      sender: MessageSender.ai,
      timestamp: DateTime.now(),
    ));

    notifyListeners();
  }

  // 호칭 변경 메서드
  void changeNickname(String nickname) {
    _currentNickname = nickname;
    notifyListeners();
  }

  // 말투 변경 메서드
  void changeFormality(String formality) {
    _formality = formality;
    notifyListeners();
  }

  // 메시지 전송 메서드
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // 사용자 메시지 추가
    _messages.add(MessageModel(
      text: text,
      sender: MessageSender.user,
      timestamp: DateTime.now(),
    ));

    // 타이핑 중 상태로 변경
    _isTyping = true;
    notifyListeners();

    // 서버에서 응답을 받아오는 시간 시뮬레이션
    await Future.delayed(const Duration(seconds: 1));

    // AI 응답 생성 (실제로는 서버에서 가져와야 함)
    String aiResponse = _generateAIResponse(text);

    // AI 메시지 추가
    _messages.add(MessageModel(
      text: aiResponse,
      sender: MessageSender.ai,
      timestamp: DateTime.now(),
    ));

    // 타이핑 중 상태 해제
    _isTyping = false;
    notifyListeners();
  }

  // 대화 내용 지우기 메서드
  void clearConversation() {
    _messages.clear();
    if (_selectedPersona != null) {
      _messages.add(MessageModel(
        text: _selectedPersona!.initialGreeting,
        sender: MessageSender.ai,
        timestamp: DateTime.now(),
      ));
    }
    notifyListeners();
  }

  // 간단한 AI 응답 생성 메서드 (실제로는 서버에서 가져와야 함)
  String _generateAIResponse(String userMessage) {
    if (_selectedPersona == null) return "AI를 먼저 선택해주세요.";

    final lowercaseMessage = userMessage.toLowerCase();

    if (lowercaseMessage.contains('안녕') || lowercaseMessage.contains('hi')) {
      if (_selectedPersona!.id == 'empathetic') {
        return "안녕하세요! 오늘 기분은 어떠신가요? 무슨 일이 있었나요?";
      } else if (_selectedPersona!.id == 'analytical') {
        return "안녕하세요. 오늘 어떤 주제에 대해 이야기 나눠볼까요?";
      } else if (_selectedPersona!.id == 'practical') {
        return "안녕하세요! 무엇을 도와드릴까요? 구체적인 문제가 있으신가요?";
      } else {
        return "안녕~ 반가워요! 오늘 기분 좋아 보이네요! 😊";
      }
    } else if (lowercaseMessage.contains('화가 나') || lowercaseMessage.contains('짜증')) {
      if (_selectedPersona!.id == 'empathetic') {
        return "그런 감정을 느끼시는 게 당연해요. 무슨 일이 있었는지 더 이야기해 주실래요?";
      } else if (_selectedPersona!.id == 'analytical') {
        return "화가 나는 상황에서는 감정과 원인을 분리해서 생각해보는 것이 도움이 됩니다. 어떤 사건이 이 감정을 유발했을까요?";
      } else if (_selectedPersona!.id == 'practical') {
        return "화가 날 때는 잠시 깊게 호흡하고, 물 한 잔 마시면서 5분간 다른 생각을 해보세요. 그런 다음 문제 해결 방법을 함께 찾아볼까요?";
      } else {
        return "화났을 때는 웃긴 고양이 영상 10초 보기! 진짜 효과만점이에요. 농담이고, 속상한 일이 있으셨군요. 어떤 일인지 편하게 말해도 괜찮아요. 😊";
      }
    } else if (lowercaseMessage.contains('연인') || lowercaseMessage.contains('남자친구') || lowercaseMessage.contains('여자친구')) {
      if (_selectedPersona!.id == 'empathetic') {
        return "연인과의 관계는 감정을 나누는 게 중요하죠. 어떤 감정을 느끼고 계신가요?";
      } else if (_selectedPersona!.id == 'analytical') {
        return "연인 관계에서는 서로의 커뮤니케이션 스타일을 이해하는 것이 중요합니다. 상대방은 어떤 스타일인가요?";
      } else if (_selectedPersona!.id == 'practical') {
        return "연인과의 갈등을 해결하는 실용적인 방법은 '나는 ~할 때 ~하게 느껴' 형식으로 대화하는 것입니다. 한번 시도해보세요.";
      } else {
        return "연애는 미스터리 영화 같아요! 결말을 예측할 수 없지만 그래서 더 재밌죠. 구체적으로 어떤 일이 있으셨나요?";
      }
    } else {
      if (_selectedPersona!.id == 'empathetic') {
        return "말씀해주셔서 감사합니다. 그런 상황이셨군요. 어떤 감정이 드셨어요?";
      } else if (_selectedPersona!.id == 'analytical') {
        return "흥미로운 내용이네요. 이 상황을 객관적으로 분석해볼까요?";
      } else if (_selectedPersona!.id == 'practical') {
        return "이해했습니다. 구체적인 해결 방법을 찾아보겠습니다. 좀 더 자세히 알려주실 수 있을까요?";
      } else {
        return "와~ 정말 재밌는 이야기네요! 더 자세히 들려주세요!";
      }
    }
  }
}