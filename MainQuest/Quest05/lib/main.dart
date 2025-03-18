import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/services/firebase_service.dart';

// Firebase 상태 관리 프로바이더
final firebaseInitializedProvider = StateProvider<bool>((ref) => false);

// Firebase 서비스 프로바이더 (오버라이드)
final firebaseServiceOverrideProvider = Provider<FirebaseService>((ref) {
  throw UnimplementedError('초기화 전에 접근');
});

Future<void> main() async {
  // Flutter 엔진 초기화 확인
  WidgetsFlutterBinding.ensureInitialized();
  
  // .env 파일 로드 (외부 API 키 등을 위한 설정)
  await dotenv.load(fileName: ".env");
  
  // API 키 확인 (출력 방법 수정)
  debugPrint('로드된 API 키: ${dotenv.get('GEMINI_API_KEY', fallback: '없음').substring(0, min(3, dotenv.get('GEMINI_API_KEY', fallback: '없음').length))}...');
  
  // Firebase는 오프라인 모드로 실행
  debugPrint('Firebase 오프라인 모드로 실행합니다');
  
  // 프로바이더 초기화
  final container = ProviderContainer(
    overrides: [
      // 오버라이드 프로바이더 설정
      firebaseServiceOverrideProvider.overrideWithValue(FirebaseService.offline()),
      // 초기화 상태 제공
      firebaseInitializedProvider.overrideWith((ref) => false),
    ],
  );
  
  runApp(
    ProviderScope(
      parent: container,
      child: const OndoChatApp(),
    ),
  );
}

int min(int a, int b) {
  return a < b ? a : b;
}
