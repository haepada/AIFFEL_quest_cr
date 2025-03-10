import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/themes/app_themes.dart';
import 'features/home/view_models/home_view_model.dart';
import 'features/chat_analysis/view_models/chat_analysis_view_model.dart';
import 'features/ai_consultation/view_models/ai_consultation_view_model.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/chat_analysis/chat_list_screen.dart';
import 'presentation/screens/ai_consultation/ai_selection_screen.dart';
import 'presentation/common/widgets/custom_nav_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => ChatAnalysisViewModel()),
        ChangeNotifierProvider(create: (_) => AIConsultationViewModel()),
      ],
      child: MaterialApp(
        title: '대화의 온도',
        debugShowCheckedModeBanner: false,
        theme: AppThemes.lightTheme,
        darkTheme: AppThemes.darkTheme,
        themeMode: ThemeMode.system, // 시스템 설정에 따라 자동으로 테마 변경
        home: const MainNavigationScreen(),
      ),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 1; // 홈이 기본 선택됨

  // 화면 목록
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const ChatListScreen(),
      const HomeScreen(),
      const AISelectionScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}