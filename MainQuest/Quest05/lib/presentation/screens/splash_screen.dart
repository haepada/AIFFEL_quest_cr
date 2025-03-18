import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../core/services/firebase_service.dart';
import 'main_screen.dart';
import '../../main.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _isFirebaseInitialized = false;
  bool _isFirebaseError = false;
  String _errorMessage = '';
  
  @override
  void initState() {
    super.initState();
    _checkFirebase();
  }
  
  Future<void> _checkFirebase() async {
    try {
      // Firebase는 오프라인 모드로 실행
      _isFirebaseInitialized = false;
      
      setState(() {});
      
      // 1.5초 후 메인 화면으로 이동
      Timer(const Duration(milliseconds: 1500), () {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const MainScreen()),
          );
        }
      });
    } catch (e) {
      setState(() {
        _isFirebaseError = true;
        _errorMessage = e.toString();
      });
      
      // 오류가 있어도 3초 후 메인 화면으로 이동
      Timer(const Duration(milliseconds: 3000), () {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const MainScreen()),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 앱 로고 및 타이틀
            Text(
              '대화의 온도',
              style: theme.textTheme.displayMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ).animate().fadeIn(duration: 600.ms),
            
            const SizedBox(height: 8),
            
            Text(
              'AI 심리 상담',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onBackground.withOpacity(0.7),
              ),
            ).animate().fadeIn(
              duration: 600.ms, 
              delay: 200.ms,
            ),
            
            const SizedBox(height: 40),
            
            // 상태 표시
            _buildStatusIndicator(),
            
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatusIndicator() {
    if (_isFirebaseError) {
      return Column(
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 48,
          ).animate().shake(),
          
          const SizedBox(height: 16),
          
          Text(
            'Firebase 연결 오류',
            style: TextStyle(
              color: Colors.red.shade700,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          
          const SizedBox(height: 8),
          
          SizedBox(
            width: 280,
            child: Text(
              '오프라인 모드로 실행합니다.\n$_errorMessage',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red.shade700,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ).animate().fadeIn();
    }
    
    // 로딩 표시
    return Column(
      children: [
        const Icon(
          Icons.cloud_off,
          color: Colors.orange,
          size: 48,
        ).animate().fadeIn(),
        
        const SizedBox(height: 16),
        
        const Text(
          '오프라인 모드로 실행합니다',
          style: TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ).animate().fadeIn();
  }
} 