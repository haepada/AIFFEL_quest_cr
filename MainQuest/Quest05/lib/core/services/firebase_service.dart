import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/counselor_persona.dart';
import '../../data/models/message.dart';
import '../../main.dart';

/// Firebase 서비스 모의 구현 (오프라인 모드 전용)
class FirebaseService {
  final bool _isOfflineMode = true;
  
  FirebaseService();
  
  /// 오프라인 모드 팩토리 생성자
  factory FirebaseService.offline() {
    debugPrint('오프라인 FirebaseService 인스턴스 생성');
    return FirebaseService();
  }
  
  /// 초기화 메서드 (오프라인 모드만 지원)
  static Future<FirebaseService> initialize() async {
    debugPrint('🔥 Firebase 오프라인 모드로 초기화');
    return FirebaseService.offline();
  }
  
  /// 오프라인 모드 여부
  bool get isOfflineMode => _isOfflineMode;
  
  /// 익명 인증 (모의 구현)
  Future<dynamic> signInAnonymously() async {
    debugPrint('오프라인 모드: 익명 로그인 건너뜁니다');
    return null;
  }
  
  /// 현재 사용자 정보 (모의 구현)
  dynamic get currentUser => null;
  
  /// 상담사 데이터 저장 (모의 구현)
  Future<void> saveCounselorData(CounselorPersona counselor) async {
    debugPrint('오프라인 모드: 상담사 데이터 저장 건너뜁니다 - ${counselor.name}');
    return;
  }
  
  /// 사용자의 상담사 목록 가져오기 (모의 구현)
  Future<List<CounselorPersona>> getUserCounselors() async {
    debugPrint('오프라인 모드: 기본 상담사만 반환합니다');
    return [];
  }
  
  /// 채팅 메시지 저장 (모의 구현)
  Future<void> saveMessage(String counselorId, Message message) async {
    debugPrint('오프라인 모드: 메시지 저장 건너뜁니다');
    return;
  }
  
  /// 상담사와의 채팅 메시지 가져오기 (모의 구현)
  Future<List<Message>> getMessages(String counselorId) async {
    debugPrint('오프라인 모드: 빈 메시지 목록 반환합니다');
    return [];
  }
}

/// Firebase 서비스 프로바이더 (main.dart에 오버라이드됨)
final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  // main.dart에서 오버라이드된 프로바이더 사용
  return ref.watch(firebaseServiceOverrideProvider);
}); 