import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  // 오늘의 대화 온도
  double _todayTemperature = 22.5;
  double get todayTemperature => _todayTemperature;

  // 오늘의 질문
  String _todayQuestion = '친구가 갑자기 화를 낼 때 당신은 어떻게 대응하나요?';
  String get todayQuestion => _todayQuestion;

  // 오늘의 날짜
  String _todayDate = '2025.03.08';
  String get todayDate => _todayDate;

  // 오늘의 대화 팁
  String _todayTip = '상대방의 감정에 먼저 공감하는 표현을 사용하면 대화의 온도를 높일 수 있습니다.';
  String get todayTip => _todayTip;

  // 유저 정보
  String _userName = '김온도';
  String get userName => _userName;

  // 이름 변경 메서드 (설정에서 사용)
  void updateUserName(String newName) {
    _userName = newName;
    notifyListeners();
  }

  // 질문에 대한 답변 제출 메서드
  Future<void> submitAnswer(String answer) async {
    // 실제 앱에서는 여기서 서버에 답변을 제출하고
    // 새로운 팁이나 인사이트를 받아올 수 있습니다.
    await Future.delayed(const Duration(seconds: 1));

    // 예시로 온도를 약간 변경
    _todayTemperature += 0.5;
    if (_todayTemperature > 30) _todayTemperature = 30;

    notifyListeners();
  }

  // 앱 실행 시 초기 데이터 로드
  Future<void> loadInitialData() async {
    // 실제 앱에서는 API나 로컬 저장소에서 데이터를 로드
    await Future.delayed(const Duration(milliseconds: 500));
    notifyListeners();
  }
}