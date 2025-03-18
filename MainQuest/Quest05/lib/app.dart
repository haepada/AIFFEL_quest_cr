import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'presentation/screens/splash_screen.dart';

// 사용자의 설정을 저장하는 provider
final userSettingsProvider = StateProvider<UserSettings>((ref) {
  return UserSettings(
    reducedMotion: false,
    highContrast: false,
    preferredTheme: 'dark',
  );
});

class UserSettings {
  final bool reducedMotion;
  final bool highContrast;
  final String preferredTheme;

  UserSettings({
    required this.reducedMotion,
    required this.highContrast,
    required this.preferredTheme,
  });

  UserSettings copyWith({
    bool? reducedMotion,
    bool? highContrast,
    String? preferredTheme,
  }) {
    return UserSettings(
      reducedMotion: reducedMotion ?? this.reducedMotion,
      highContrast: highContrast ?? this.highContrast,
      preferredTheme: preferredTheme ?? this.preferredTheme,
    );
  }
}

class OndoChatApp extends ConsumerWidget {
  const OndoChatApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userSettings = ref.watch(userSettingsProvider);
    final themeMode = userSettings.preferredTheme == 'dark' 
        ? ThemeMode.dark 
        : ThemeMode.light;

    return MaterialApp(
      title: '대화의 온도',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: _buildLightTheme(context, userSettings),
      darkTheme: _buildDarkTheme(context, userSettings),
      home: const SplashScreen(),
    );
  }

  // 라이트 테마 설정 - 글라스모피즘 스타일
  ThemeData _buildLightTheme(BuildContext context, UserSettings settings) {
    // 부드러운 그라데이션 컬러 팔레트
    final colorScheme = ColorScheme.light(
      primary: const Color(0xFF7B68EE),       // 소프트 퍼플
      primaryContainer: const Color(0xFFE6E1FD),
      secondary: const Color(0xFFFF89B0),     // 소프트 핑크
      secondaryContainer: const Color(0xFFFFD9E3),
      surface: Colors.white.withOpacity(0.85),
      background: const Color(0xFFF8F9FE),
      onBackground: const Color(0xFF303345),
      error: const Color(0xFFE5484D),
    );

    // 글라스모피즘 앱 테마
    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: colorScheme.primary,
      scaffoldBackgroundColor: colorScheme.background,
      
      // 시스템 UI 오버레이 설정
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
        ),
        backgroundColor: Colors.white.withOpacity(0.75),
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      
      // 글라스 카드 스타일
      cardTheme: CardTheme(
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        color: Colors.white.withOpacity(0.6),
        shadowColor: Colors.black.withOpacity(0.1),
      ),
      
      // 글라스 버튼 스타일
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: colorScheme.primary.withOpacity(0.9),
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
        ),
      ),
      
      // 아웃라인 버튼 (라인 없음)
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white.withOpacity(0.3),
          foregroundColor: colorScheme.primary,
          side: BorderSide.none,
        ),
      ),
      
      // 텍스트 버튼
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          foregroundColor: colorScheme.primary,
          backgroundColor: Colors.transparent,
        ),
      ),
      
      // 폰트 설정
      fontFamily: 'NotoSansKR',
      textTheme: TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: colorScheme.onBackground),
        displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: colorScheme.onBackground),
        displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: colorScheme.onBackground),
        headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: colorScheme.onBackground),
        headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: colorScheme.onBackground),
        headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: colorScheme.onBackground),
        titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: colorScheme.onBackground),
        titleMedium: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: colorScheme.onBackground),
        titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colorScheme.onBackground.withOpacity(0.9)),
        bodyLarge: TextStyle(fontSize: 16, height: 1.5, color: colorScheme.onBackground.withOpacity(0.9)), 
        bodyMedium: TextStyle(fontSize: 14, height: 1.5, color: colorScheme.onBackground.withOpacity(0.85)),
        bodySmall: TextStyle(fontSize: 13, height: 1.5, color: colorScheme.onBackground.withOpacity(0.8)),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.5, color: colorScheme.onBackground.withOpacity(0.9)),
        labelMedium: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, letterSpacing: 0.5, color: colorScheme.onBackground.withOpacity(0.85)),
        labelSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.5, color: colorScheme.onBackground.withOpacity(0.8)),
      ),
      
      // 구분선 (거의 보이지 않게)
      dividerTheme: DividerThemeData(
        thickness: 0.5,
        color: colorScheme.onBackground.withOpacity(0.05),
      ),
      
      // 입력 필드 - 글라스모피즘 스타일
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.6),
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.error.withOpacity(0.5), width: 1),
        ),
        hintStyle: TextStyle(
          color: colorScheme.onBackground.withOpacity(0.5),
          fontSize: 14,
        ),
      ),
      
      // 슬라이더 테마
      sliderTheme: SliderThemeData(
        thumbColor: colorScheme.primary,
        activeTrackColor: colorScheme.primary,
        inactiveTrackColor: colorScheme.primary.withOpacity(0.2),
        trackHeight: 4,
        thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: 8,
          elevation: 2,
        ),
        overlayShape: RoundSliderOverlayShape(
          overlayRadius: 18.0,
        ),
      ),
      
      // 칩 테마
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white.withOpacity(0.7),
        selectedColor: colorScheme.primary.withOpacity(0.9),
        secondarySelectedColor: colorScheme.primaryContainer.withOpacity(0.7),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        labelStyle: TextStyle(fontSize: 14, color: colorScheme.onBackground),
        secondaryLabelStyle: TextStyle(fontSize: 14, color: colorScheme.primary),
        brightness: Brightness.light,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        side: BorderSide.none,
        elevation: 0,
      ),
      
      // 바텀시트 테마
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.white,
        modalBackgroundColor: Colors.white,
        modalElevation: 0,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
      ),
      
      // 다이얼로그 테마
      dialogTheme: DialogTheme(
        backgroundColor: Colors.white.withOpacity(0.9),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      
      // 스낵바 테마
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.onBackground.withOpacity(0.8),
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // 다크 테마 설정 - 글라스모피즘 스타일
  ThemeData _buildDarkTheme(BuildContext context, UserSettings settings) {
    // 다크모드 컬러 팔레트
    final colorScheme = ColorScheme.dark(
      primary: const Color(0xFFB0A4FF),       // 라이트 퍼플
      primaryContainer: const Color(0xFF4A3E9A),
      secondary: const Color(0xFFFFAAC8),     // 라이트 핑크
      secondaryContainer: const Color(0xFFB5476A),
      surface: const Color(0xFF1E1E2E).withOpacity(0.85),
      background: const Color(0xFF121122),
      onBackground: Colors.white.withOpacity(0.9),
      error: const Color(0xFFFF6B6B),
    );

    // 다크 글라스모피즘 앱 테마
    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: colorScheme.primary,
      scaffoldBackgroundColor: colorScheme.background,
      
      // 시스템 UI 오버레이 설정
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
        ),
        backgroundColor: const Color(0xFF1E1E2E).withOpacity(0.7),
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      
      // 글라스 카드 스타일
      cardTheme: CardTheme(
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        color: const Color(0xFF2A2A3C).withOpacity(0.6),
        shadowColor: Colors.black.withOpacity(0.1),
      ),
      
      // 글라스 버튼 스타일
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: colorScheme.primary.withOpacity(0.9),
          foregroundColor: Colors.black.withOpacity(0.8),
          shadowColor: Colors.transparent,
        ),
      ),
      
      // 아웃라인 버튼 (라인 없음)
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: const Color(0xFF2A2A3C).withOpacity(0.4),
          foregroundColor: colorScheme.primary,
          side: BorderSide.none,
        ),
      ),
      
      // 텍스트 버튼
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          foregroundColor: colorScheme.primary,
          backgroundColor: Colors.transparent,
        ),
      ),
      
      // 폰트 설정
      fontFamily: 'NotoSansKR',
      textTheme: TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: colorScheme.onBackground),
        displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: colorScheme.onBackground),
        displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: colorScheme.onBackground),
        headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: colorScheme.onBackground),
        headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: colorScheme.onBackground),
        headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: colorScheme.onBackground),
        titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: colorScheme.onBackground),
        titleMedium: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: colorScheme.onBackground),
        titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colorScheme.onBackground.withOpacity(0.9)),
        bodyLarge: TextStyle(fontSize: 16, height: 1.5, color: colorScheme.onBackground.withOpacity(0.9)), 
        bodyMedium: TextStyle(fontSize: 14, height: 1.5, color: colorScheme.onBackground.withOpacity(0.85)),
        bodySmall: TextStyle(fontSize: 13, height: 1.5, color: colorScheme.onBackground.withOpacity(0.8)),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.5, color: colorScheme.onBackground.withOpacity(0.9)),
        labelMedium: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, letterSpacing: 0.5, color: colorScheme.onBackground.withOpacity(0.85)),
        labelSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.5, color: colorScheme.onBackground.withOpacity(0.8)),
      ),
      
      // 구분선 (거의 보이지 않게)
      dividerTheme: DividerThemeData(
        thickness: 0.5,
        color: colorScheme.onBackground.withOpacity(0.1),
      ),
      
      // 입력 필드 - 글라스모피즘 스타일
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2A2A3C).withOpacity(0.5),
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.error.withOpacity(0.5), width: 1),
        ),
        hintStyle: TextStyle(
          color: colorScheme.onBackground.withOpacity(0.5),
          fontSize: 14,
        ),
      ),
      
      // 슬라이더 테마
      sliderTheme: SliderThemeData(
        thumbColor: colorScheme.primary,
        activeTrackColor: colorScheme.primary,
        inactiveTrackColor: colorScheme.primary.withOpacity(0.2),
        trackHeight: 4,
        thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: 8,
          elevation: 1,
        ),
        overlayShape: RoundSliderOverlayShape(
          overlayRadius: 18.0,
        ),
      ),
      
      // 칩 테마
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF2A2A3C).withOpacity(0.6),
        selectedColor: colorScheme.primary.withOpacity(0.9),
        secondarySelectedColor: colorScheme.primaryContainer.withOpacity(0.6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        labelStyle: TextStyle(fontSize: 14, color: colorScheme.onBackground),
        secondaryLabelStyle: TextStyle(fontSize: 14, color: colorScheme.primary),
        brightness: Brightness.dark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        side: BorderSide.none,
        elevation: 0,
      ),
      
      // 바텀시트 테마
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: const Color(0xFF1E1E2E).withOpacity(0.9),
        modalBackgroundColor: const Color(0xFF1E1E2E).withOpacity(0.9),
        modalElevation: 0,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
      ),
      
      // 다이얼로그 테마
      dialogTheme: DialogTheme(
        backgroundColor: const Color(0xFF1E1E2E).withOpacity(0.9),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      
      // 스낵바 테마
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.onBackground.withOpacity(0.8),
        contentTextStyle: const TextStyle(color: Color(0xFF121122)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
} 