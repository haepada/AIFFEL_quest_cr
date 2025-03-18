import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'counseling/counseling_screen.dart';
import 'history/chat_history_screen.dart';

/// 앱의 메인 화면 - 상담하기/상담기록보기 탭이 있는 하단 네비게이션 바 포함
class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const CounselingScreen(),
    const ChatHistoryScreen(),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        elevation: 3,
        shadowColor: Theme.of(context).colorScheme.shadow,
        height: 64,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble),
            label: '상담하기',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: '상담기록',
          ),
        ],
      ),
    );
  }
} 