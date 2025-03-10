import 'dart:io';
import 'package:flutter/material.dart';
import '../models/chat_model.dart';
import '../models/analysis_result_model.dart';
import '../models/suggestion_model.dart';

class ChatAnalysisViewModel extends ChangeNotifier {
  // 대화 목록
  final List<ChatModel> _chatList = [
    ChatModel(
      id: 1,
      name: '김서연',
      relationship: '연인',
      lastMessage: '오늘 저녁에 영화 보러 갈래?',
      lastAnalyzed: '오늘',
      messageCount: 126,
      temperature: 24.5,
    ),
    ChatModel(
      id: 2,
      name: '이팀장님',
      relationship: '직장 상사',
      lastMessage: '이번 기획안 언제까지 완료 가능한가요?',
      lastAnalyzed: '어제',
      messageCount: 43,
      temperature: 14.2,
    ),
    ChatModel(
      id: 3,
      name: '박지연',
      relationship: '친구',
      lastMessage: '주말에 시간 있어? 같이 브런치 먹으러 가자!',
      lastAnalyzed: '2일 전',
      messageCount: 78,
      temperature: 22.8,
    ),
  ];

  List<ChatModel> get chatList => _chatList;

  // 현재 선택된 대화
  ChatModel? _selectedChat;
  ChatModel? get selectedChat => _selectedChat;

  // 분석 결과
  AnalysisResultModel? _analysisResult;
  AnalysisResultModel? get analysisResult => _analysisResult;

  // 대화 추천 목록
  List<SuggestionModel> _suggestions = [];
  List<SuggestionModel> get suggestions => _suggestions;

  // 선택된 관계 유형
  String? _selectedRelationship;
  String? get selectedRelationship => _selectedRelationship;

  // 선택된 대화 목적
  String? _selectedPurpose;
  String? get selectedPurpose => _selectedPurpose;

  // 설정된 온도
  double _temperature = 22.0;
  double get temperature => _temperature;

  // 대화 업로드 모드
  String? _uploadMode;
  String? get uploadMode => _uploadMode;

  // 대화 선택 메서드
  void selectChat(ChatModel chat) {
    _selectedChat = chat;
    notifyListeners();
  }

  // 관계 유형 선택 메서드
  void selectRelationship(String relationship) {
    _selectedRelationship = relationship;
    notifyListeners();
  }

  // 대화 목적 선택 메서드
  void selectPurpose(String purpose) {
    _selectedPurpose = purpose;
    notifyListeners();
  }

  // 온도 설정 메서드
  void setTemperature(double temp) {
    _temperature = temp;
    notifyListeners();
  }

  // 업로드 모드 설정 메서드
  void setUploadMode(String mode) {
    _uploadMode = mode;
    notifyListeners();
  }

  // 대화 파일 업로드 메서드
  Future<void> uploadChatFile(File file) async {
    // 실제 앱에서는 파일을 파싱하거나 서버에 전송
    await Future.delayed(const Duration(seconds: 2));
    _uploadMode = 'kakaotalk';
    notifyListeners();
  }

  // 대화 스크린샷 업로드 메서드
  Future<void> uploadChatScreenshot(File image) async {
    // 실제 앱에서는 이미지를 분석하거나 서버에 전송
    await Future.delayed(const Duration(seconds: 2));
    _uploadMode = 'screenshot';
    notifyListeners();
  }

  // 대화 분석 시작 메서드
  Future<void> startAnalysis() async {
    // 실제 앱에서는 서버 또는 로컬 ML 모델로 분석 실행
    await Future.delayed(const Duration(seconds: 3));

    // 샘플 분석 결과 생성
    _analysisResult = AnalysisResultModel(
      temperature: 15.5,
      expressionStyles: {
        'logical': 65,
        'emotional': 15,
        'empathetic': 20,
        'direct': 70,
      },
      patterns: [
        "직설적인 표현이 많아 상대방이 부담을 느낄 수 있습니다.",
        "상대방의 감정에 대한 공감 표현이 부족합니다.",
      ],
      partnerPatterns: [
        "상대방은 감정 표현이 풍부한 편입니다.",
        "질문을 통해 의견을 묻는 경향이 있습니다.",
      ],
      suggestions: [
        "상대방의 질문에 단답형으로 답하기보다 이유나 감정을 함께 표현해보세요.",
        "\"~해도 될까?\", \"~하면 어떨까?\" 등 부드러운 제안 형식을 활용해보세요.",
      ],
    );

    // 샘플 추천 대화 생성
    _suggestions = [
      SuggestionModel(
          text: "이번 주는 일이 있어서 어려울 것 같아. 다음 주에는 어때?",
          temperature: 25.0,
          type: "대안 제시",
          effect: "상대방 배려"
      ),
      SuggestionModel(
          text: "지금 마감 업무가 있어서 시간이 안 될 것 같네. 미안해.",
          temperature: 18.0,
          type: "이유 설명",
          effect: "이해 도모"
      ),
      SuggestionModel(
          text: "일정이 너무 빡빡해서 오늘은 힘들 것 같아.",
          temperature: 12.0,
          type: "직접 설명",
          effect: "명확한 상황 전달"
      ),
    ];

    notifyListeners();
  }

  // 새 대화 추가 메서드
  void addNewChat(ChatModel chat) {
    _chatList.insert(0, chat);
    notifyListeners();
  }

  // 분석 결과 초기화 메서드
  void resetAnalysis() {
    _selectedChat = null;
    _analysisResult = null;
    _suggestions = [];
    _selectedRelationship = null;
    _selectedPurpose = null;
    _temperature = 22.0;
    _uploadMode = null;
    notifyListeners();
  }
}