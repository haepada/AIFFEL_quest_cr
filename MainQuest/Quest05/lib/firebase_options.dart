/// 이 파일은 Firebase 연동을 위한 설정 파일입니다.
/// 실제 Firebase 설정이 필요할 때는 flutterfire configure 명령어로 생성해야 합니다.
/// 현재는 오프라인 모드로 실행되므로 이 파일의 내용은 사용되지 않습니다.

import 'package:flutter/foundation.dart';

/// Firebase 설정 클래스 (오프라인 모드 전용 모의 구현)
class DefaultFirebaseOptions {
  /// 현재 플랫폼에 맞는 Firebase 옵션 반환
  static dynamic get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    return android;
  }
  
  /// 웹 플랫폼 설정 (임시값)
  static final dynamic web = {};
  
  /// 안드로이드 플랫폼 설정 (임시값)
  static final dynamic android = {};
} 