import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import '../../../data/models/counselor_persona.dart';
import '../../../data/providers/state/counseling_providers.dart';
import '../../../app.dart';
import 'chat_screen.dart';
import 'persona_creation_screen.dart';
import 'package:flutter/rendering.dart';

class CounselingScreen extends ConsumerStatefulWidget {
  const CounselingScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CounselingScreen> createState() => _CounselingScreenState();
}

class _CounselingScreenState extends ConsumerState<CounselingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isFirstVisit = false; // 앱 첫 방문 여부 (온보딩용)
  
  // 필터링 상태 변수 추가
  String? _selectedFilter;
  bool _showRoleplayOnly = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    Future.microtask(() {
      _animateItems();
      _checkFirstVisit();
    });
  }

  // 첫 방문 확인 및 온보딩 표시
  void _checkFirstVisit() {
    // 실제 앱에서는 SharedPreferences 등으로 첫 방문 여부 확인
    // 온보딩 제거 - 팝업을 표시하지 않음
    setState(() {
      _isFirstVisit = false;
    });
  }
  
  // 온보딩 툴팁 표시 기능 비활성화
  void _showOnboardingTooltip() {
    // 팝업 제거 - 아무 작업도 수행하지 않음
  }

  // 아이템 애니메이션 시작
  void _animateItems() {
    final userSettings = ref.read(userSettingsProvider);
    
    if (!userSettings.reducedMotion) {
      _animationController.forward();
    } else {
      // 모션 감소 모드에서는 애니메이션 없이 바로 표시
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final counselors = ref.watch(counselorPersonasProvider);
    final userSettings = ref.watch(userSettingsProvider);
    final textScaleFactor = MediaQuery.textScaleFactorOf(context);
    
    // 필터링된 상담사 목록 계산
    final filteredCounselors = counselors.where((counselor) {
      // 롤플레이 필터 적용
      if (_showRoleplayOnly) {
        return counselor.isRoleplay;
      }
      
      // 전문 분야 필터 적용
      if (_selectedFilter != null) {
        return counselor.specialties.contains(_selectedFilter);
      }
      
      // 필터 없으면 모두 반환
      return true;
    }).toList();
    
    // 기본 상담사와 커스텀 상담사 분리
    final basicCounselors = filteredCounselors.where((c) => !c.isCustom).toList();
    final customCounselors = filteredCounselors.where((c) => c.isCustom).toList();
    
    // 텍스트 크기에 따라 여백 조정
    final responsivePadding = EdgeInsets.all(16 * (textScaleFactor <= 1 ? 1 : (1 / textScaleFactor * 0.8)));

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('대화의 온도'),
            Text(
              'AI 상담사 & 롤플레이',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          // 접근성 메뉴 버튼
          IconButton(
            icon: const Icon(Icons.settings_accessibility),
            tooltip: '접근성 설정',
            onPressed: _showAccessibilitySettings,
          ),
        ],
      ),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return CustomScrollView(
              slivers: [
                // 헤더 (검색 및 필터 섹션)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: responsivePadding,
                    child: _buildSearchFilterSection(
                      _animationController.value,
                      userSettings.reducedMotion,
                    ),
                  ),
                ),
                
                // 필터링 결과 표시
                if (_selectedFilter != null || _showRoleplayOnly)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: responsivePadding.copyWith(top: 0, bottom: 16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.filter_list,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _showRoleplayOnly 
                                ? '롤플레이 상담사 결과' 
                                : '\'$_selectedFilter\' 검색 결과',
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const Spacer(),
                          // 필터 초기화 버튼
                          TextButton.icon(
                            icon: const Icon(Icons.refresh, size: 16),
                            label: const Text('필터 초기화'),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                              minimumSize: const Size(0, 30),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {
                              setState(() {
                                _selectedFilter = null;
                                _showRoleplayOnly = false;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                
                // 필터링 결과가 없을 때 메시지
                if (filteredCounselors.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: responsivePadding.copyWith(top: 32, bottom: 32),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 48,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '검색 결과가 없습니다',
                              style: Theme.of(context).textTheme.titleMedium,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '다른 필터를 선택하거나 새 상담사를 만들어보세요',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _selectedFilter = null;
                                  _showRoleplayOnly = false;
                                });
                              },
                              icon: const Icon(Icons.refresh),
                              label: const Text('필터 초기화'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                
                // 기본 상담사 섹션 제목 (필터링 결과가 있을 때만 표시)
                if (basicCounselors.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: responsivePadding.copyWith(bottom: 8, top: 24),
                      child: Row(
                        children: [
                          Icon(
                            Icons.psychology_alt,
                            size: 20,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '기본 상담사',
                            style: Theme.of(context).textTheme.titleLarge,
                            semanticsLabel: '기본 AI 상담사 목록',
                          ),
                        ],
                      ),
                    ),
                  ),
                
                // 기본 상담사 리스트 (필터링 결과가 있을 때만 표시)
                if (basicCounselors.isNotEmpty)
                  SliverToBoxAdapter(
                    child: _buildBasicCounselorsList(basicCounselors, userSettings.reducedMotion),
                  ),
                
                // 커스텀 상담사 섹션 제목
                SliverToBoxAdapter(
                  child: Padding(
                    padding: responsivePadding.copyWith(bottom: 8, top: 24),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                Icons.person,
                                size: 20,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '나의 상담사',
                                style: Theme.of(context).textTheme.titleLarge,
                                semanticsLabel: '커스텀 AI 상담사 목록',
                              ),
                            ],
                          ),
                        ),
                        // 새 상담사 만들기 버튼
                        TextButton.icon(
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('새 상담사'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PersonaCreationScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                
                // 커스텀 상담사 그리드
                SliverPadding(
                  padding: responsivePadding,
                  sliver: customCounselors.isEmpty
                      ? SliverToBoxAdapter(
                          child: _buildEmptyState(userSettings.reducedMotion),
                        )
                      : SliverGrid(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: _calculateCrossAxisCount(context),
                            childAspectRatio: 0.8,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final counselor = customCounselors[index];
                              final delay = (index * 0.05);
                              
                              // 애니메이션 적용
                              return Transform.translate(
                                offset: Offset(
                                  0,
                                  userSettings.reducedMotion ? 0 : (1 - _animationController.value) * 50 * (1 + delay),
                                ),
                                child: Opacity(
                                  opacity: userSettings.reducedMotion ? 1 : _animationController.value,
                                  child: _buildCounselorCard(
                                    counselor, 
                                    userSettings.reducedMotion, 
                                    false // 그리드 아이템은 기본 리스트가 아님
                                  ),
                                ),
                              );
                            },
                            childCount: customCounselors.length,
                          ),
                        ),
                ),
                
                // 하단 여백
                const SliverToBoxAdapter(
                  child: SizedBox(height: 40),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
  
  // 화면 크기에 따라 그리드 열 수 계산
  int _calculateCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 900) {
      return 4; // 태블릿 가로
    } else if (width > 600) {
      return 3; // 태블릿 세로
    } else if (width > 400) {
      return 2; // 모바일 가로
    } else {
      return 1; // 작은 모바일 화면 세로
    }
  }
  
  // 접근성 설정 다이얼로그
  void _showAccessibilitySettings() {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final userSettings = ref.watch(userSettingsProvider);
            
            return Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
                        width: 0.5,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.settings_accessibility,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '접근성 설정',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        // 모션 감소 설정
                        SwitchListTile(
                          title: const Text('모션 감소'),
                          subtitle: const Text('애니메이션 효과 최소화'),
                          value: userSettings.reducedMotion,
                          onChanged: (value) {
                            ref.read(userSettingsProvider.notifier).state = 
                                userSettings.copyWith(reducedMotion: value);
                          },
                          secondary: const Icon(Icons.animation),
                        ),
                        
                        // 고대비 모드 설정
                        SwitchListTile(
                          title: const Text('고대비 모드'),
                          subtitle: const Text('텍스트와 배경 간 대비 향상'),
                          value: userSettings.highContrast,
                          onChanged: (value) {
                            ref.read(userSettingsProvider.notifier).state = 
                                userSettings.copyWith(highContrast: value);
                          },
                          secondary: const Icon(Icons.contrast),
                        ),
                        
                        // 테마 설정
                        ListTile(
                          title: const Text('테마'),
                          subtitle: Text(userSettings.preferredTheme == 'dark' ? '다크 모드' : '라이트 모드'),
                          leading: const Icon(Icons.brightness_6),
                          trailing: DropdownButton<String>(
                            value: userSettings.preferredTheme,
                            onChanged: (value) {
                              if (value != null) {
                                ref.read(userSettingsProvider.notifier).state = 
                                    userSettings.copyWith(preferredTheme: value);
                              }
                            },
                            items: const [
                              DropdownMenuItem(
                                value: 'light',
                                child: Text('라이트 모드'),
                              ),
                              DropdownMenuItem(
                                value: 'dark',
                                child: Text('다크 모드'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('확인'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
  
  // 검색 및 필터 섹션
  Widget _buildSearchFilterSection(double animationValue, bool reducedMotion) {
    return Transform.translate(
      offset: Offset(0, reducedMotion ? 0 : (1 - animationValue) * 30),
      child: Opacity(
        opacity: reducedMotion ? 1 : animationValue,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '당신의 마음을 나눌 상담사를 선택하세요',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            
            // 검색창
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '상담사 이름 또는 전문분야 검색',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: false,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    ),
                  ),
                ),
              ),
            ),
            
            // 빠른 필터 칩
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    // 추천 필터
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                        child: ActionChip(
                          avatar: Icon(
                            Icons.star, 
                            size: 18,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          label: const Text('추천'),
                          backgroundColor: _selectedFilter == null
                              ? Theme.of(context).colorScheme.primary.withOpacity(0.15)
                              : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                          side: BorderSide(
                            color: _selectedFilter == null
                                ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
                                : Theme.of(context).colorScheme.outline.withOpacity(0.3),
                            width: 1,
                          ),
                          onPressed: () {
                            setState(() {
                              _selectedFilter = null;
                              _showRoleplayOnly = false;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    
                    // 롤플레이 필터
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                        child: FilterChip(
                          label: const Text('롤플레이'),
                          selected: _showRoleplayOnly,
                          backgroundColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                          side: BorderSide(
                            color: _showRoleplayOnly
                                ? Colors.orange.withOpacity(0.7)
                                : Theme.of(context).colorScheme.outline.withOpacity(0.3),
                            width: 1,
                          ),
                          onSelected: (selected) {
                            setState(() {
                              _showRoleplayOnly = selected;
                              if(selected) {
                                _selectedFilter = null;
                              }
                            });
                          },
                          avatar: Icon(
                            Icons.theater_comedy, 
                            size: 18,
                            color: _showRoleplayOnly ? Colors.orange : null,
                          ),
                          checkmarkColor: Colors.orange,
                          selectedColor: Colors.orange.withOpacity(0.15),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    
                    // 자존감 필터
                    _buildSpecialtyFilterChip('자존감'),
                    const SizedBox(width: 8),
                    
                    // 관계 갈등 필터
                    _buildSpecialtyFilterChip('관계 갈등'),
                    const SizedBox(width: 8),
                    
                    // 불안 관리 필터
                    _buildSpecialtyFilterChip('불안 관리'),
                    const SizedBox(width: 8),
                    
                    // 스트레스 필터
                    _buildSpecialtyFilterChip('스트레스 관리'),
                    const SizedBox(width: 8),
                    
                    // 직장 문제 필터
                    _buildSpecialtyFilterChip('직장 문제'),
                    const SizedBox(width: 8),
                    
                    // 인간관계 필터
                    _buildSpecialtyFilterChip('인간관계'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // 전문 분야 필터 칩 생성 함수
  Widget _buildSpecialtyFilterChip(String specialty) {
    final isSelected = _selectedFilter == specialty;
    final theme = Theme.of(context);
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: FilterChip(
          label: Text(
            specialty,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected 
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface,
            ),
          ),
          selected: isSelected,
          backgroundColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
          selectedColor: theme.colorScheme.primary,
          side: BorderSide(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withOpacity(0.3),
            width: 1.5,
          ),
          onSelected: (selected) {
            setState(() {
              _selectedFilter = selected ? specialty : null;
              _showRoleplayOnly = false;
            });
          },
          checkmarkColor: theme.colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        ),
      ),
    );
  }

  // 빈 상태 UI (커스텀 상담사가 없을 때)
  Widget _buildEmptyState(bool reducedMotion) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.person_add,
                size: 48,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
              )
              .animate(
                target: reducedMotion ? 0 : 1,
              )
              .scaleXY(
                begin: 0.8,
                end: 1,
                duration: 400.ms,
                curve: Curves.easeOutBack,
              ),
              const SizedBox(height: 16),
              Text(
                '나만의 상담사를 만들어보세요',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '당신이 원하는 성격, 스타일, 전문성을 가진\n맞춤형 AI 상담사를 직접 만들 수 있어요',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PersonaCreationScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('새 상담사 만들기'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 44),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 기본 상담사 리스트 빌드 (카드 뷰)
  Widget _buildBasicCounselorsList(List<CounselorPersona> counselors, bool reducedMotion) {
    if (counselors.isEmpty) {
      return SizedBox.shrink();
    }
    
    return StatefulBuilder(
      builder: (context, setState) {
        // PageController는 StatefulBuilder 내부에서 생성하고 관리
        final PageController controller = PageController(
          viewportFraction: 0.85,
          initialPage: 0,
        );
        
        // 현재 페이지 상태 추적
        final ValueNotifier<int> currentPage = ValueNotifier<int>(0);
        
        // 컨트롤러 리스너 추가
        controller.addListener(() {
          if (controller.page != null) {
            final newPage = controller.page!.round();
            if (currentPage.value != newPage) {
              currentPage.value = newPage;
            }
          }
        });
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 8),
              child: Text(
                '기본 제공 상담사',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 350, // 고정 높이 설정
              child: Stack(
                children: [
                  // PageView로 변경
                  PageView.builder(
                    controller: controller,
                    itemCount: counselors.length,
                    physics: const BouncingScrollPhysics(),
                    onPageChanged: (index) {
                      // 페이지 변경 시 상태 업데이트
                      currentPage.value = index;
                    },
                    itemBuilder: (context, index) {
                      final counselor = counselors[index];
                      final delay = (index * 0.1);
                      
                      // 애니메이션 적용
                      return Transform.translate(
                        offset: Offset(
                          reducedMotion ? 0 : (1 - _animationController.value) * 100 * (1 + delay),
                          0,
                        ),
                        child: Opacity(
                          opacity: reducedMotion ? 1 : _animationController.value,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.85,
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            child: _buildCounselorCard(counselor, reducedMotion, true),
                          ),
                        ),
                      );
                    },
                  ),
                  
                  // 좌우 버튼 추가
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ValueListenableBuilder<int>(
                        valueListenable: currentPage,
                        builder: (context, pageIndex, _) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // 왼쪽 버튼
                              ClipOval(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: pageIndex > 0 
                                          ? () => controller.animateToPage(
                                              pageIndex - 1,
                                              duration: Duration(milliseconds: 300),
                                              curve: Curves.easeInOut,
                                            ) 
                                          : null,
                                      customBorder: const CircleBorder(),
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
                                          border: Border.all(
                                            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                            width: 1,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.chevron_left,
                                          color: pageIndex > 0
                                              ? Theme.of(context).colorScheme.onSurface 
                                              : Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              
                              // 오른쪽 버튼
                              ClipOval(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: pageIndex < counselors.length - 1
                                          ? () => controller.animateToPage(
                                              pageIndex + 1,
                                              duration: Duration(milliseconds: 300),
                                              curve: Curves.easeInOut,
                                            )
                                          : null,
                                      customBorder: const CircleBorder(),
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
                                          border: Border.all(
                                            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                            width: 1,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.chevron_right,
                                          color: pageIndex < counselors.length - 1
                                              ? Theme.of(context).colorScheme.onSurface
                                              : Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // 페이지 인디케이터 추가
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ValueListenableBuilder<int>(
                valueListenable: currentPage,
                builder: (context, pageIndex, _) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(counselors.length, (index) {
                      final isCurrentPage = index == pageIndex;
                      
                      return GestureDetector(
                        onTap: () {
                          controller.animateToPage(
                            index,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          width: isCurrentPage ? 16 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: isCurrentPage
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.primary.withOpacity(0.3),
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  // 상담사 카드 빌드
  Widget _buildCounselorCard(
    CounselorPersona counselor, 
    bool reducedMotion,
    bool isBasicList,
  ) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: GestureDetector(
        onTap: () => _openChatScreen(counselor),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: theme.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 상단 그라데이션 헤더
              Container(
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  gradient: LinearGradient(
                    colors: counselor.gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    // 아바타
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            counselor.avatarEmoji,
                            style: TextStyle(fontSize: 32),
                          ),
                        ),
                      ),
                    ),
                    // 이름과 태그
                    Positioned(
                      top: 18,
                      left: 90,
                      right: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            counselor.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          if (counselor.isRoleplay)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '롤플레이',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // 상담사 정본 본문
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 설명
                      Text(
                        counselor.description,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 12),
                      
                      // 전문 분야
                      Text(
                        '전문 분야',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      SizedBox(height: 4),
                      
                      // 전문 분야 태그들
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: counselor.specialties.take(3).map((specialty) {
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: theme.colorScheme.primary.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Text(
                              specialty,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: theme.colorScheme.onPrimary,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      
                      Spacer(),
                      
                      // 채팅 시작 버튼
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _openChatScreen(counselor),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text('대화 시작하기'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ).animate(
        target: reducedMotion ? 0 : 1,
      ).fadeIn(
        duration: 400.ms, 
        delay: 200.ms,
        curve: Curves.easeOutQuad,
      ).slideY(
        begin: 0.2, 
        end: 0, 
        duration: 400.ms, 
        delay: 100.ms,
        curve: Curves.easeOutQuad,
      ),
    );
  }

  // 상담사 선택 시 채팅 화면으로 이동
  void _openChatScreen(CounselorPersona counselor) {
    _handleCounselorTap(context, counselor);
  }

  void _handleCounselorTap(BuildContext context, CounselorPersona counselor) {
    // 상담사 선택
    ref.read(selectedCounselorProvider.notifier).state = counselor;
    
    // 채팅 화면으로 이동 전에 상담사 메시지 초기화 설정
    final chatMessages = ref.read(chatMessagesProvider(counselor.id).notifier);
    chatMessages.setInitialMessage(counselor);
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          counselor: counselor,
        ),
      ),
    );
  }
} 