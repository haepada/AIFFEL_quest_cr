import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import '../../../data/models/counselor_persona.dart';
import '../../../data/providers/state/counseling_providers.dart';
import '../../../app.dart';
import 'chat_screen.dart';

class PersonaCreationScreen extends ConsumerStatefulWidget {
  // 편집을 위한 상담사 매개변수 추가
  final CounselorPersona? editingCounselor;
  
  const PersonaCreationScreen({
    Key? key, 
    this.editingCounselor,
  }) : super(key: key);

  @override
  ConsumerState<PersonaCreationScreen> createState() => _PersonaCreationScreenState();
}

class _PersonaCreationScreenState extends ConsumerState<PersonaCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _introductionController = TextEditingController();
  
  // 롤플레이 관련 컨트롤러
  final _roleplayScenarioController = TextEditingController();
  final _roleplayGoalController = TextEditingController();
  final Map<String, TextEditingController> _contextControllers = {};
  
  // 참조 대화 내용 관련 컨트롤러 추가
  final _referenceChatController = TextEditingController();
  bool _useReferenceChat = false;
  
  // 참조 대화 분석 결과 변수 추가
  bool _hasAnalyzedChat = false;
  
  String _selectedEmoji = '😊';
  List<String> _selectedSpecialties = [];
  bool _isRoleplay = false;
  String _chatStyle = '친근한 격식체';
  
  // 롤플레이 관련 변수
  String _roleplayCategory = '취업/면접';
  List<String> _contextFields = [];
  
  // 성격 특성 값 (0-100)
  int _empathyValue = 50;
  int _directnessValue = 50;
  int _humorValue = 50;
  
  // 그라데이션 색상 관련
  Color _primaryColor = Colors.blue.shade500;
  Color _secondaryColor = Colors.purple.shade500;
  
  // 모드 선택 (일반/롤플레이)
  int _selectedModeIndex = 0;
  
  // 이모지 선택 옵션
  final List<String> _emojiOptions = [
    '😊', '🌟', '🌈', '🌱', '🌲', '🌊', '🔮', '🧠', '🧘‍♀️', '🤔',
    '🧐', '📚', '🏆', '💡', '❤️', '🧡', '💛', '💚', '💙', '💜',
    '⭐', '🔆', '🏵️', '🌺', '🌸', '🌼', '🍀', '🌿', '🌱', '🥇',
  ];
  
  // 전문 분야 옵션
  final List<String> _specialtyOptions = [
    '자존감', '불안 관리', '스트레스 관리', '우울증', '분노 조절',
    '관계 개선', '자기 계발', '커리어 상담', '인간관계', '의사소통',
    '습관 형성', '목표 설정', '일상 문제', '사랑과 연애', '가족 관계',
    '직장 문제', '자기 성찰', '동기 부여', '감정 관리', '트라우마',
    '변화 관리', '성격 유형', '강점 발견', '행복 증진', '롤플레이',
  ];
  
  // 채팅 스타일 옵션
  List<String> _chatStyles = [
    '친근한 격식체',
    '편안한 비격식체', 
    '전문적인 격식체',
    '상냥한 공감체',
    '분석적 설명체',
    '친구같은 반말체',
    '꼰대스러운 설교체', 
    '스승같은 멘토체',
    '재미있는 유머체',
    '시적 표현체',
  ];
  
  // 전문성 수준 옵션
  List<String> _expertiseLevels = [
    '일반적인 조언',
    '중급 전문가',
    '고급 전문가',
    '최고 수준 전문가',
  ];

  // 선택된 값 상태 변수
  String _selectedChatStyle = '친근한 격식체';
  String _selectedExpertiseLevel = '중급 전문가';
  int _jargonLevel = 3;
  
  // 롤플레이 카테고리 옵션
  final List<String> _roleplayCategoryOptions = [
    '취업/면접',
    '연애/관계',
    '사회생활',
    '학업/교육',
    '가족관계',
    '기타',
  ];
  
  // 롤플레이 카테고리별 기본 컨텍스트 필드
  final Map<String, List<String>> _defaultContextFields = {
    '취업/면접': ['회사명', '직무/포지션', '회사규모', '회사특성', '면접유형'],
    '연애/관계': ['관계유형', '만난기간', '상대방특성', '현재상황', '갈등원인'],
    '사회생활': ['상황유형', '인간관계', '갈등요소', '목표', '환경'],
    '학업/교육': ['학교/교육기관', '과목/분야', '학년/레벨', '목표', '어려움'],
    '가족관계': ['가족구성원', '관계특성', '갈등요소', '지속기간', '목표'],
    '기타': ['상황', '참여자', '목표', '어려움', '배경'],
  };

  @override
  void initState() {
    super.initState();
    
    // 편집 모드인 경우 기존 상담사 정보로 필드 초기화
    if (widget.editingCounselor != null) {
      final counselor = widget.editingCounselor!;
      
      // 기본 정보 설정
      _nameController.text = counselor.name;
      _descriptionController.text = counselor.description;
      _introductionController.text = counselor.introduction;
      _selectedEmoji = counselor.avatarEmoji;
      _selectedSpecialties = List.from(counselor.specialties);
      _primaryColor = counselor.gradientColors[0];
      _secondaryColor = counselor.gradientColors.length > 1 
          ? counselor.gradientColors[1] 
          : counselor.gradientColors[0];
      
      // 성격 특성 설정
      _empathyValue = counselor.personality['empathy'] ?? 50;
      _directnessValue = counselor.personality['directness'] ?? 50;
      _humorValue = counselor.personality['humor'] ?? 50;
      
      // 말투 설정
      _selectedChatStyle = counselor.chatStyle;
      _selectedExpertiseLevel = counselor.expertiseLevel;
      _jargonLevel = counselor.jargonLevel;
      
      // 롤플레이 설정
      _isRoleplay = counselor.isRoleplay;
      if (counselor.isRoleplay && counselor.roleplayCategory != null) {
        _roleplayCategory = counselor.roleplayCategory!;
        _roleplayScenarioController.text = counselor.roleplayScenario ?? '';
        _roleplayGoalController.text = counselor.roleplayGoal ?? '';
        
        // 컨텍스트 필드 설정
        _updateContextFields(_roleplayCategory);
        
        // 컨텍스트 값 설정
        if (counselor.roleplayContext != null) {
          counselor.roleplayContext!.forEach((key, value) {
            if (_contextControllers.containsKey(key)) {
              _contextControllers[key]!.text = value;
            }
          });
        }
      }
    }
    
    // 참조 대화 컨트롤러에 리스너 추가
    _referenceChatController.addListener(_analyzeReferenceChat);
    
    // 롤플레이 관련 필드 설정
    _updateContextFields(_roleplayCategory);
  }

  // 롤플레이 카테고리에 따라 컨텍스트 필드 업데이트
  void _updateContextFields(String category) {
    setState(() {
      _roleplayCategory = category;
      _contextFields = _defaultContextFields[category] ?? [];
      
      // 컨트롤러 업데이트
      final Map<String, TextEditingController> newControllers = {};
      for (final field in _contextFields) {
        newControllers[field] = _contextControllers[field] ?? TextEditingController();
      }
      
      // 기존 컨트롤러 dispose
      for (final controller in _contextControllers.values) {
        if (!newControllers.values.contains(controller)) {
          controller.dispose();
        }
      }
      
      _contextControllers.clear();
      _contextControllers.addAll(newControllers);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _introductionController.dispose();
    _roleplayScenarioController.dispose();
    _roleplayGoalController.dispose();
    
    // 롤플레이 컨텍스트 컨트롤러 정리
    for (final controller in _contextControllers.values) {
      controller.dispose();
    }
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userSettings = ref.watch(userSettingsProvider);
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final basePadding = 16.0 * textScaleFactor;
    
    // 검증 상태 추적용 변수들
    final List<String> validationErrors = [];
    
    // 모든 필드 검증 함수 추가
    void validateAllFields() {
      validationErrors.clear();
      
      // 모든 모드에서 공통 검증
      if (_nameController.text.isEmpty) validationErrors.add('상담사 이름을 입력해주세요');
      if (_descriptionController.text.isEmpty) validationErrors.add('상담사 설명을 입력해주세요');
      
      // 일반 상담에서만 검증
      if (!_isRoleplay && _selectedSpecialties.isEmpty) {
        validationErrors.add('하나 이상의 전문 분야를 선택해주세요');
      }
      
      // 롤플레이 모드에서만 검증
      if (_isRoleplay) {
        if (_roleplayScenarioController.text.isEmpty) {
          validationErrors.add('롤플레이 상황을 입력해주세요');
        }
        if (_roleplayGoalController.text.isEmpty) {
          validationErrors.add('롤플레이 목표를 입력해주세요');
        }
        
        // 참조 대화 검증
        if (_useReferenceChat && _referenceChatController.text.isEmpty) {
          validationErrors.add('참조 대화 내용을 입력해주세요');
        }
        
        // 모든 컨텍스트 필드 검증
        for (final field in _contextFields) {
          if (_contextControllers[field]?.text.isEmpty ?? true) {
            validationErrors.add('$field 정보를 입력해주세요');
          }
        }
      }
    }
    
    // 초기 검증 실행
    validateAllFields();
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_isRoleplay ? '롤플레이 상담사 만들기' : '일반 상담사 만들기'),
        backgroundColor: _isRoleplay ? Colors.orange.shade700 : Theme.of(context).primaryColor,
        actions: [
          TextButton(
            onPressed: () {
              // 폼 검증 재실행
              validateAllFields();
              
              if (validationErrors.isEmpty) {
                _validateAndSave();
              } else {
                // 에러 목록 표시
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('입력이 완료되지 않았습니다. 모든 필수 필드를 채워주세요.'),
                    backgroundColor: Colors.red.shade800,
                    duration: Duration(seconds: 3),
                  ),
                );
                
                // 에러 목록 다이얼로그 표시
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('입력 확인'),
                    content: SizedBox(
                      width: double.maxFinite,
                      child: ListView(
                        shrinkWrap: true,
                        children: validationErrors
                            .map((error) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    children: [
                                      Icon(Icons.error_outline, 
                                           color: Colors.red.shade700,
                                           size: 18),
                                      SizedBox(width: 8),
                                      Expanded(child: Text(error)),
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('확인'),
                      ),
                    ],
                  ),
                );
              }
            },
            child: Text('저장', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Form(
          key: _formKey,
          child: SafeArea(
            child: Column(
              children: [
                // 모드 선택 탭 - 더 크고 눈에 띄게 변경
                Container(
                  margin: EdgeInsets.all(basePadding),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isRoleplay = false;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: !_isRoleplay 
                                  ? Colors.blue.withOpacity(0.2)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                              border: !_isRoleplay ? Border.all(
                                color: Colors.blue.shade600,
                                width: 2,
                              ) : null,
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.psychology,
                                  color: !_isRoleplay 
                                      ? Colors.blue.shade700
                                      : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                  size: 28,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '일반 상담사',
                                  style: TextStyle(
                                    fontWeight: !_isRoleplay ? FontWeight.bold : FontWeight.normal,
                                    color: !_isRoleplay
                                        ? Colors.blue.shade700
                                        : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isRoleplay = true;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: _isRoleplay 
                                  ? Colors.orange.withOpacity(0.2)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                              border: _isRoleplay ? Border.all(
                                color: Colors.orange.shade600,
                                width: 2,
                              ) : null,
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.theater_comedy,
                                  color: _isRoleplay
                                      ? Colors.orange.shade700
                                      : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                  size: 28,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '롤플레이',
                                  style: TextStyle(
                                    fontWeight: _isRoleplay ? FontWeight.bold : FontWeight.normal,
                                    color: _isRoleplay
                                        ? Colors.orange.shade700
                                        : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // 모드 구분선
                Container(
                  width: double.infinity,
                  height: 4,
                  margin: EdgeInsets.symmetric(horizontal: basePadding),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _isRoleplay
                          ? [Colors.orange.shade300, Colors.orange.shade500]
                          : [Colors.blue.shade300, Colors.blue.shade500],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                
                // 모드 설명
                Container(
                  margin: EdgeInsets.only(
                    left: basePadding, 
                    right: basePadding, 
                    top: basePadding
                  ),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _isRoleplay 
                        ? Colors.orange.withOpacity(0.1)
                        : Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _isRoleplay 
                          ? Colors.orange.withOpacity(0.5)
                          : Colors.blue.withOpacity(0.5),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        _isRoleplay ? Icons.info_outline : Icons.lightbulb_outline,
                        color: _isRoleplay ? Colors.orange.shade700 : Colors.blue.shade700,
                        size: 24,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isRoleplay ? '롤플레이 모드' : '일반 상담 모드',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: _isRoleplay ? Colors.orange.shade800 : Colors.blue.shade800,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              _isRoleplay
                                  ? '롤플레이 모드에서는 특정 역할을 수행하는 상담사를 만들 수 있습니다. 롤플레이 상담사는 설정한 역할과 맥락에 따라 응답합니다.'
                                  : '일반 상담사 모드에서는 성격, 말투, 전문성을 설정하여 다양한 주제에 대응하는 상담사를 만들 수 있습니다.',
                              style: TextStyle(
                                fontSize: 14,
                                color: _isRoleplay ? Colors.orange.shade800 : Colors.blue.shade800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // 스크롤 가능한 내용
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(basePadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 색상 미리보기
                          _buildColorPreview(),
                          const SizedBox(height: 24),
                          
                          // 기본 정보 섹션
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.08),
                                width: 0.5,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.person, color: Theme.of(context).colorScheme.primary),
                                    SizedBox(width: 8),
                                    Text(
                                      '기본 정보',
                                      style: Theme.of(context).textTheme.titleLarge,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                
                                // 상담사 이름 입력
                                TextFormField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                    labelText: '상담사 이름',
                                    hintText: '상담사의 이름을 입력해주세요',
                                    prefixIcon: const Icon(Icons.person_outline),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  validator: (value) => (value?.isEmpty ?? true) 
                                      ? '상담사 이름을 입력해주세요' 
                                      : null,
                                ),
                                const SizedBox(height: 16),
                                
                                // 설명 입력
                                TextFormField(
                                  controller: _descriptionController,
                                  maxLength: 100,
                                  decoration: InputDecoration(
                                    labelText: '상담사 설명',
                                    hintText: '상담사를 간단히 설명해주세요',
                                    prefixIcon: Icon(Icons.description_outlined),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return '설명을 입력해주세요';
                                    }
                                    return null;
                                  },
                                ),
                                
                                // 이모지 선택 (일반 상담사일 때만)
                                if (!_isRoleplay) ...[
                                  const SizedBox(height: 16),
                                  Text(
                                    '대표 이모지 선택',
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      itemCount: _emojiOptions.length,
                                      itemBuilder: (context, index) {
                                        final emoji = _emojiOptions[index];
                                        final isSelected = _selectedEmoji == emoji;
                                        
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _selectedEmoji = emoji;
                                            });
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                                            width: 44,
                                            decoration: BoxDecoration(
                                              color: isSelected ? Theme.of(context).colorScheme.primaryContainer : Colors.transparent,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Center(
                                              child: Text(
                                                emoji,
                                                style: const TextStyle(fontSize: 24),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // 일반 상담사 설정
                          if (!_isRoleplay) ...[
                            // 전문 분야 선택
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.08),
                                  width: 0.5,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.category, color: Theme.of(context).colorScheme.primary),
                                      SizedBox(width: 8),
                                      Text(
                                        '전문 분야',
                                        style: Theme.of(context).textTheme.titleLarge,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '상담사의 전문 분야를 1-5개 선택해주세요',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: _specialtyOptions.map((specialty) {
                                      final isSelected = _selectedSpecialties.contains(specialty);
                                      return FilterChip(
                                        label: Text(specialty),
                                        selected: isSelected,
                                        onSelected: (selected) {
                                          setState(() {
                                            if (selected) {
                                              if (_selectedSpecialties.length < 5) {
                                                _selectedSpecialties.add(specialty);
                                              } else {
                                                // 최대 5개 제한 알림
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text('최대 5개까지 선택할 수 있습니다'),
                                                    backgroundColor: Colors.red.shade700,
                                                    duration: Duration(seconds: 2),
                                                  ),
                                                );
                                              }
                                            } else {
                                              _selectedSpecialties.remove(specialty);
                                            }
                                          });
                                        },
                                      );
                                    }).toList(),
                                  ),
                                  if (_selectedSpecialties.isEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.warning_amber_rounded,
                                            color: Theme.of(context).colorScheme.error,
                                            size: 16,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            '최소 1개 이상의 전문 분야를 선택해주세요',
                                            style: TextStyle(
                                              color: Theme.of(context).colorScheme.error,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // 상담사 성격 및 말투 설정
                            _buildPersonalitySettingsCard(context),
                            
                            const SizedBox(height: 24),
                            
                            // 전문성 설정
                            _buildExpertiseSettingsCard(context),
                          ],
                          
                          // 롤플레이 설정
                          if (_isRoleplay) ...[
                            _buildRoleplaySettings(),
                          ],
                          
                          // 저장 버튼
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () {
                                if (validationErrors.isEmpty) {
                                  _validateAndSave();
                                } else {
                                  // 에러 목록 다이얼로그 표시
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('입력 확인'),
                                      content: SizedBox(
                                        width: double.maxFinite,
                                        child: ListView(
                                          shrinkWrap: true,
                                          children: validationErrors
                                              .map((error) => Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                                    child: Row(
                                                      children: [
                                                        Icon(Icons.error_outline, 
                                                             color: Colors.red.shade700,
                                                             size: 18),
                                                        SizedBox(width: 8),
                                                        Expanded(child: Text(error)),
                                                      ],
                                                    ),
                                                  ))
                                              .toList(),
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(),
                                          child: Text('확인'),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isRoleplay ? Colors.orange.shade600 : _primaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                _isRoleplay ? '롤플레이 상담사 저장하기' : '일반 상담사 저장하기',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          
                          // 하단 여백
                          const SizedBox(height: 40),
                          
                          // 유효성 검사 오류 표시
                          if (validationErrors.isNotEmpty) ...[
                            const SizedBox(height: 24),
                            _buildValidationErrorsCard(context, validationErrors),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  // 미리보기 위젯
  Widget _buildColorPreview() {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_primaryColor, _secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  _selectedEmoji,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _nameController.text.isEmpty ? '새 상담사' : _nameController.text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // 성격 및 말투 설정 카드
  Widget _buildPersonalitySettingsCard(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.psychology, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  '성격 및 말투 설정',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // 공감도 슬라이더
            _buildSlider(
              label: '공감도',
              value: _empathyValue.toDouble(),
              icon: Icons.favorite,
              minLabel: '분석적',
              maxLabel: '공감적',
              activeColor: Colors.orange.shade600,
              onChanged: (value) {
                setState(() {
                  _empathyValue = value.round();
                });
              },
            ),
            const SizedBox(height: 16),
            
            // 직설적 표현 슬라이더
            _buildSlider(
              label: '직설적 표현',
              value: _directnessValue.toDouble(),
              icon: Icons.chat_bubble,
              minLabel: '간접적',
              maxLabel: '직설적',
              activeColor: Colors.orange.shade600,
              onChanged: (value) {
                setState(() {
                  _directnessValue = value.round();
                });
              },
            ),
            const SizedBox(height: 16),
            
            // 유머 감각 슬라이더
            _buildSlider(
              label: '유머 감각',
              value: _humorValue.toDouble(),
              icon: Icons.mood,
              minLabel: '진지함',
              maxLabel: '유머러스',
              onChanged: (value) {
                setState(() {
                  _humorValue = value.round();
                });
              },
            ),
            const SizedBox(height: 24),
            
            // 말투 선택 (RadioButtons로 변경)
            Text(
              '대화 말투',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            _buildChatStyleSelector(),
          ],
        ),
      ),
    );
  }
  
  // 전문성 설정 카드
  Widget _buildExpertiseSettingsCard(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.school, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  '전문성 설정',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // 전문성 수준 (RadioButtons로 변경)
            Text(
              '전문성 수준',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            _buildExpertiseLevelSelector(),
            const SizedBox(height: 24),
            
            // 전문용어 사용 정도 슬라이더
            Text(
              '전문용어 사용 정도',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('쉬운 용어', style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                Text('어려운 용어', style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _jargonLevel.toDouble(),
                    min: 1,
                    max: 5,
                    divisions: 4,
                    label: _getJargonLevelLabel(_jargonLevel),
                    onChanged: (value) {
                      setState(() {
                        _jargonLevel = value.round();
                      });
                    },
                  ),
                ),
                Container(
                  width: 32,
                  alignment: Alignment.center,
                  child: Text(
                    _jargonLevel.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            
            // 미리보기
            const SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '설정 미리보기',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(_getExpertiseLevelPreview()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // 말투 스타일 선택 위젯
  Widget _buildChatStyleSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        // 말투 그룹 1: 격식체
        _buildChatStyleGroup(
          '격식체', 
          ['친근한 격식체', '전문적인 격식체', '상냥한 공감체', '분석적 설명체']
        ),
        
        // 말투 그룹 2: 비격식체
        _buildChatStyleGroup(
          '비격식체', 
          ['편안한 비격식체', '친구같은 반말체', '꼰대스러운 설교체', '스승같은 멘토체', '재미있는 유머체', '시적 표현체']
        ),
      ],
    );
  }
  
  // 말투 스타일 그룹 위젯
  Widget _buildChatStyleGroup(String groupTitle, List<String> styles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 4),
          child: Text(
            groupTitle,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).hintColor,
            ),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: styles.map((style) {
            return ChoiceChip(
              label: Text(style),
              selected: _selectedChatStyle == style,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedChatStyle = style;
                  });
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }
  
  // 전문성 수준 선택 위젯
  Widget _buildExpertiseLevelSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _expertiseLevels.map((level) {
        return ChoiceChip(
          label: Text(level),
          selected: _selectedExpertiseLevel == level,
          onSelected: (selected) {
            if (selected) {
              setState(() {
                _selectedExpertiseLevel = level;
              });
            }
          },
        );
      }).toList(),
    );
  }
  
  // 슬라이더 위젯
  Widget _buildSlider({
    required String label,
    required double value,
    required IconData icon,
    required String minLabel,
    required String maxLabel,
    required ValueChanged<double> onChanged,
    Color? activeColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: activeColor ?? Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              minLabel,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).hintColor,
              ),
            ),
            Expanded(
              child: Slider(
                value: value,
                min: 0,
                max: 100,
                divisions: 10,
                activeColor: activeColor,
                onChanged: onChanged,
              ),
            ),
            Text(
              maxLabel,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).hintColor,
              ),
            ),
            Container(
              width: 32,
              alignment: Alignment.center,
              child: Text(
                '${value.round()}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: activeColor ?? Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  // 유효성 검사 오류 카드
  Widget _buildValidationErrorsCard(BuildContext context, List<String> errors) {
    return Card(
      color: Colors.red.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.red.shade300,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.red.shade700),
                const SizedBox(width: 8),
                Text(
                  '입력을 완료해주세요',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...errors.map(
              (error) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red.shade700, size: 16),
                    const SizedBox(width: 8),
                    Expanded(child: Text(error)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // 전문용어 수준 라벨 가져오기
  String _getJargonLevelLabel(int level) {
    switch (level) {
      case 1: return '매우 쉬움';
      case 2: return '쉬움';
      case 3: return '보통';
      case 4: return '전문적';
      case 5: return '매우 전문적';
      default: return '보통';
    }
  }
  
  // 전문성 수준 미리보기 텍스트
  String _getExpertiseLevelPreview() {
    String expertiseText = '';
    
    switch(_selectedExpertiseLevel) {
      case '일반적인 조언':
        expertiseText = '친근하고 일상적인 언어로 조언을 제공합니다. ';
        break;
      case '중급 전문가':
        expertiseText = '적절한 전문 지식을 바탕으로 조언을 제공합니다. ';
        break;
      case '고급 전문가':
        expertiseText = '깊이 있는 전문 지식과 통찰력으로 상세한 분석을 제공합니다. ';
        break;
      case '최고 수준 전문가':
        expertiseText = '해당 분야 최고 권위자 수준의 전문성으로 고급 분석과 해결책을 제시합니다. ';
        break;
      default:
        expertiseText = '적절한 전문 지식을 바탕으로 조언을 제공합니다. ';
    }
    
    switch(_jargonLevel) {
      case 1:
        expertiseText += '전문용어는 거의 사용하지 않고 쉬운 말로 설명합니다.';
        break;
      case 2:
        expertiseText += '간단한 전문용어만 사용하고 바로 설명을 덧붙입니다.';
        break;
      case 3:
        expertiseText += '적절한 수준의 전문용어를 사용하되 필요시 설명을 추가합니다.';
        break;
      case 4:
        expertiseText += '전문용어를 자연스럽게 활용하며 깊이 있는 설명을 제공합니다.';
        break;
      case 5:
        expertiseText += '학술적이고 전문적인 용어를 적극 활용하여 설명합니다.';
        break;
      default:
        expertiseText += '적절한 수준의 전문용어를 사용하되 필요시 설명을 추가합니다.';
    }
    
    return expertiseText;
  }

  // 롤플레이 카테고리 설명 텍스트
  String _getCategoryDescription(String category) {
    switch (category) {
      case '취업/면접':
        return '취업 면접관, 커리어 코치 등 직업 관련 역할을 상담사가 맡아 실제와 같은 면접을 연습하거나 경력 상담을 받을 수 있습니다.';
      case '연애/관계':
        return '연인, 데이트 상대 등의 역할을 상담사가 맡아 대화 연습이나 관계 문제에 대한 상담을 받을 수 있습니다.';
      case '사회생활':
        return '상사, 동료, 고객 등 사회생활에서 만나는 역할을 상담사가 맡아 실제 상황에 대비한 대화를 연습할 수 있습니다.';
      case '학업/교육':
        return '교수, 선생님, 멘토 등 교육 관련 역할을 상담사가 맡아 학습 상담이나 질의응답을 연습할 수 있습니다.';
      case '가족관계':
        return '부모, 자녀, 형제 등 가족 구성원의 역할을 상담사가 맡아 가족과의 대화나 문제 해결을 연습할 수 있습니다.';
      case '기타':
        return '그 외 다양한 상황에서의 역할 연기가 가능합니다. 원하는 역할과 상황을 자세히 설명해주세요.';
      default:
        return '';
    }
  }

  // 롤플레이 설정 섹션
  Widget _buildRoleplaySettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 롤플레이 카테고리 선택
        Text(
          '롤플레이 카테고리',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        // 카테고리 옵션들
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _roleplayCategoryOptions.map((category) {
            return ChoiceChip(
              label: Text(category),
              selected: _roleplayCategory == category,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _roleplayCategory = category;
                    // 카테고리에 맞는 컨텍스트 필드 업데이트
                    _updateContextFields(category);
                  });
                }
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        
        // 롤플레이 상황 설명
        TextFormField(
          controller: _roleplayScenarioController,
          decoration: InputDecoration(
            labelText: '롤플레이 상황',
            hintText: '어떤 상황에서의 대화를 연습하고 싶으신가요?',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          validator: (value) {
            if (_isRoleplay && (value == null || value.isEmpty)) {
              return '롤플레이 상황을 입력해주세요';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        // 롤플레이 목표
        TextFormField(
          controller: _roleplayGoalController,
          decoration: InputDecoration(
            labelText: '롤플레이 목표',
            hintText: '이 대화를 통해 어떤 결과를 얻고 싶으신가요?',
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
          validator: (value) {
            if (_isRoleplay && (value == null || value.isEmpty)) {
              return '롤플레이 목표를 입력해주세요';
            }
            return null;
          },
        ),
        const SizedBox(height: 24),
        
        // 참조 대화 입력 섹션 추가
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.08),
              width: 0.5,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: ExpansionTile(
              initiallyExpanded: _useReferenceChat,
              backgroundColor: _useReferenceChat 
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.05)
                  : Colors.transparent,
              collapsedBackgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              title: Row(
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    color: _useReferenceChat
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '실제 대화 참조하기',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: _useReferenceChat
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '기존 대화를 참조하여 상대방의 말투와 대화 패턴을 학습합니다',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  if (_hasAnalyzedChat && _isRoleplay && _useReferenceChat)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.green.withOpacity(0.3),
                            width: 0.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 14,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '대화 분석 완료',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              trailing: Switch(
                value: _useReferenceChat,
                onChanged: (value) {
                  setState(() {
                    _useReferenceChat = value;
                    _hasAnalyzedChat = false; // 스위치 상태 변경 시 분석 상태 초기화
                  });
                },
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '대화 입력 방법',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  '아래 형식으로 대화를 입력해주세요:',
                                  style: TextStyle(fontSize: 13),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '상대방: 안녕하세요?\n나: 안녕하세요! 오늘 기분이 어떠세요?\n상대방: 날씨가 좋아서 기분이 좋네요 ㅎㅎ',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'monospace',
                                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  '• 최근 10일 이내의 대화를 복사하여 붙여넣어주세요.\n'
                                  '• 최소 5-10회 이상의 대화 내용을 포함하면 좋습니다.\n'
                                  '• 상대방의 말투, 어휘 선택, 이모지 사용이 잘 드러날수록 효과적입니다.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    height: 1.4,
                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _referenceChatController,
                        decoration: InputDecoration(
                          labelText: '참조할 대화 내용',
                          hintText: '상대방: 안녕하세요?\n나: 안녕하세요, 오늘 어떻게 지내세요?\n상대방: 좋아요! 날씨가 참 좋네요.\n나: 네, 정말 좋은 날씨네요. 주말 계획 있으세요?',
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,
                          fillColor: _useReferenceChat 
                              ? Theme.of(context).colorScheme.surface
                              : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                          filled: true,
                        ),
                        maxLines: 10,
                        minLines: 6,
                        enabled: _useReferenceChat,
                        validator: (value) {
                          if (_useReferenceChat && (value == null || value.isEmpty)) {
                            return '참조 대화 내용을 입력해주세요';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        
        // 롤플레이 컨텍스트 필드들
        Text(
          '${_roleplayCategory} 상황 정보',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        // 현재 카테고리에 맞는 컨텍스트 필드들 생성
        for (final field in _contextFields)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TextFormField(
              controller: _contextControllers[field],
              decoration: InputDecoration(
                labelText: field,
                hintText: '$field 정보를 입력해주세요',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (_isRoleplay && (value == null || value.isEmpty)) {
                  return '$field를 입력해주세요';
                }
                return null;
              },
            ),
          ),
      ],
    );
  }

  void _validateAndSave() {
    // 모든 필드 검증 - 재확인
    final List<String> errors = [];
    
    // 모든 모드에서 공통 검증
    if (_nameController.text.isEmpty) errors.add('상담사 이름을 입력해주세요');
    if (_descriptionController.text.isEmpty) errors.add('상담사 설명을 입력해주세요');
    
    // 일반 상담에서만 검증
    if (!_isRoleplay && _selectedSpecialties.isEmpty) {
      errors.add('하나 이상의 전문 분야를 선택해주세요');
    }
    
    // 롤플레이 모드에서만 검증
    if (_isRoleplay) {
      if (_roleplayScenarioController.text.isEmpty) {
        errors.add('롤플레이 상황을 입력해주세요');
      }
      if (_roleplayGoalController.text.isEmpty) {
        errors.add('롤플레이 목표를 입력해주세요');
      }
      
      // 참조 대화 검증
      if (_useReferenceChat && _referenceChatController.text.isEmpty) {
        errors.add('참조 대화 내용을 입력해주세요');
      }
      
      // 모든 컨텍스트 필드 검증
      for (final field in _contextFields) {
        if (_contextControllers[field]?.text.isEmpty ?? true) {
          errors.add('$field 정보를 입력해주세요');
        }
      }
    }
    
    if (errors.isNotEmpty) {
      // 에러가 있으면 메시지 표시 후 종료
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('입력이 완료되지 않았습니다: ${errors.first}'),
          backgroundColor: Colors.red.shade800,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }
    
    // 여기서부터는 모든 검증을 통과한 경우만 실행
    final counselors = ref.read(counselorPersonasProvider.notifier);
    
    // 사용자 입력 값으로 상담사 생성
    final CounselorPersona newCounselor;
    
    // 롤플레이 상담사인 경우
    if (_isRoleplay) {
      // 롤플레이 컨텍스트 구성
      Map<String, String> contextData = {};
      for (final field in _contextFields) {
        contextData[field] = _contextControllers[field]?.text.trim() ?? '';
      }
      
      // 롤플레이 정보 생성
      final roleplayInfo = RoleplayInfo(
        category: _roleplayCategory,
        scenario: _roleplayScenarioController.text.trim(),
        goal: _roleplayGoalController.text.trim(),
        contextData: contextData,
        useReferenceChat: _useReferenceChat,
        referenceChat: _useReferenceChat ? _referenceChatController.text.trim() : '',
      );
      
      // 이전 버전과의 호환성을 위한 롤플레이 컨텍스트
      Map<String, String> legacyRoleplayContext = {...contextData};
      
      // 참조 대화 정보 추가 (이전 버전 호환성)
      if (_useReferenceChat && _referenceChatController.text.isNotEmpty) {
        legacyRoleplayContext['참조대화'] = _referenceChatController.text.trim();
        legacyRoleplayContext['대화참조사용'] = 'true';
      } else {
        legacyRoleplayContext['대화참조사용'] = 'false';
      }
      
      if (_roleplayCategory == '취업/면접') {
        newCounselor = CounselorPersona.careerRoleplay(
          name: _nameController.text,
          description: _descriptionController.text,
          scenario: _roleplayScenarioController.text,
          context: legacyRoleplayContext,
          goal: _roleplayGoalController.text,
          personality: {
            'empathy': _empathyValue,
            'directness': _directnessValue,
            'humor': _humorValue,
          },
          expertiseLevel: _selectedExpertiseLevel,
        ).copyWith(
          roleplay: roleplayInfo, // 새로운 roleplay 필드 추가
        );
      } else if (_roleplayCategory == '연애/관계') {
        newCounselor = CounselorPersona.relationshipRoleplay(
          name: _nameController.text,
          description: _descriptionController.text,
          scenario: _roleplayScenarioController.text,
          context: legacyRoleplayContext,
          goal: _roleplayGoalController.text,
          personality: {
            'empathy': _empathyValue,
            'directness': _directnessValue,
            'humor': _humorValue,
          },
          expertiseLevel: _selectedExpertiseLevel,
        ).copyWith(
          roleplay: roleplayInfo, // 새로운 roleplay 필드 추가
        );
      } else {
        newCounselor = CounselorPersona.roleplay(
          name: _nameController.text,
          description: _descriptionController.text,
          category: _roleplayCategory,
          scenario: _roleplayScenarioController.text,
          context: legacyRoleplayContext,
          goal: _roleplayGoalController.text,
          personality: {
            'empathy': _empathyValue,
            'directness': _directnessValue,
            'humor': _humorValue,
          },
          chatStyle: _selectedChatStyle,
          expertiseLevel: _selectedExpertiseLevel,
        ).copyWith(
          roleplay: roleplayInfo, // 새로운 roleplay 필드 추가
        );
      }
    } else {
      // 일반 상담사 생성
      final String counselorId = widget.editingCounselor != null 
          ? widget.editingCounselor!.id  // 편집 모드면 기존 ID 유지
          : 'custom_${DateTime.now().millisecondsSinceEpoch}'; // 신규면 새 ID 생성
      
      newCounselor = CounselorPersona(
        id: counselorId,
        name: _nameController.text,
        avatarEmoji: _selectedEmoji,
        description: _descriptionController.text,
        specialties: _selectedSpecialties.where((s) => s.isNotEmpty).toList(),
        gradientColors: [_primaryColor, _secondaryColor],
        personality: {
          'empathy': _empathyValue,
          'directness': _directnessValue,
          'humor': _humorValue,
        },
        introduction: _introductionController.text.isEmpty 
            ? '안녕하세요! 저는 ${_nameController.text}입니다. 어떤 이야기든 편하게 나눠주세요.'
            : _introductionController.text,
        chatStyle: _selectedChatStyle,
        expertiseLevel: _selectedExpertiseLevel,
        jargonLevel: _jargonLevel,
        isCustom: true,
      );
    }
    
    // 상담사 수정 또는 추가
    if (widget.editingCounselor != null) {
      // 기존 상담사 업데이트
      counselors.updateCounselor(newCounselor);
      
      // 수정 성공 메시지
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('상담사가 성공적으로 업데이트되었습니다!'),
          backgroundColor: Colors.green.shade700,
          duration: Duration(seconds: 2),
        ),
      );
      
      // 수정 완료 플래그 반환
      Navigator.of(context).pop(true);
    } else {
      // 새 상담사 추가
      counselors.addCounselor(newCounselor);
      
      // 성공 알림
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('상담사가 성공적으로 생성되었습니다!'),
          backgroundColor: Colors.green.shade700,
          duration: Duration(seconds: 2),
        ),
      );
      
      // 상담 화면으로 돌아가기
      Navigator.of(context).pop();
    }
  }

  // 참조 대화 자동 분석 함수
  void _analyzeReferenceChat() {
    // 롤플레이 모드이고 참조 대화 기능이 활성화된 경우만 처리
    if (!_isRoleplay || !_useReferenceChat || _referenceChatController.text.isEmpty) {
      return;
    }
    
    // 이미 분석한 경우는 재분석하지 않음 (너무 자주 호출되는 것 방지)
    if (_hasAnalyzedChat) {
      return;
    }
    
    final chatText = _referenceChatController.text;
    
    // 대화 분석에 충분한 양의 텍스트가 있는지 확인 (최소 100자)
    if (chatText.length < 100) {
      return;
    }
    
    // 대화로부터 정보 추출
    _extractInformationFromChat(chatText);
    
    // 분석 완료 표시
    setState(() {
      _hasAnalyzedChat = true;
    });
  }
  
  // 대화에서 정보 추출 및 필드 자동 채우기
  void _extractInformationFromChat(String chatText) {
    // 1. 대화 주제 식별
    final lines = chatText.split('\n');
    final conversations = <String>[];
    
    // 대화 내용만 추출
    for (var line in lines) {
      if (line.contains(':')) {
        conversations.add(line.split(':').last.trim());
      }
    }
    
    // 모든 대화를 하나의 문자열로 합침
    final fullText = conversations.join(' ');
    
    // 2. 카테고리 추론
    if (_detectJobInterview(fullText)) {
      setState(() {
        _roleplayCategory = '취업/면접';
        _updateContextFields('취업/면접');
        _populateJobInterviewFields(fullText);
      });
    } else if (_detectRelationship(fullText)) {
      setState(() {
        _roleplayCategory = '연애/관계';
        _updateContextFields('연애/관계');
        _populateRelationshipFields(fullText);
      });
    } else if (_detectAcademic(fullText)) {
      setState(() {
        _roleplayCategory = '학업/교육';
        _updateContextFields('학업/교육');
        _populateAcademicFields(fullText);
      });
    } else if (_detectFamilyIssue(fullText)) {
      setState(() {
        _roleplayCategory = '가족관계';
        _updateContextFields('가족관계');
        _populateFamilyFields(fullText);
      });
    } else {
      setState(() {
        _roleplayCategory = '사회생활';
        _updateContextFields('사회생활');
        _populateSocialFields(fullText);
      });
    }
    
    // 3. 롤플레이 시나리오, 목표 자동 설정
    _generateScenarioAndGoal(fullText);
  }
  
  // 취업/면접 대화 감지
  bool _detectJobInterview(String text) {
    final jobKeywords = [
      '면접', '취업', '채용', '회사', '직무', '직장', '경력', '이력서', 
      '자기소개', '스펙', '자격증', '포트폴리오', '인터뷰', '지원자'
    ];
    
    int matchCount = 0;
    for (var keyword in jobKeywords) {
      if (text.contains(keyword)) {
        matchCount++;
      }
    }
    
    return matchCount >= 3;
  }
  
  // 연애/관계 대화 감지
  bool _detectRelationship(String text) {
    final relationshipKeywords = [
      '연애', '데이트', '연인', '남자친구', '여자친구', '남친', '여친', '사랑',
      '고백', '썸', '짝사랑', '이별', '헤어짐', '다툼', '화해', '결혼'
    ];
    
    int matchCount = 0;
    for (var keyword in relationshipKeywords) {
      if (text.contains(keyword)) {
        matchCount++;
      }
    }
    
    return matchCount >= 3;
  }
  
  // 학업/교육 대화 감지
  bool _detectAcademic(String text) {
    final academicKeywords = [
      '학교', '수업', '과제', '시험', '공부', '교수', '선생님', '학생', 
      '성적', '논문', '졸업', '입시', '교육', '강의', '학점'
    ];
    
    int matchCount = 0;
    for (var keyword in academicKeywords) {
      if (text.contains(keyword)) {
        matchCount++;
      }
    }
    
    return matchCount >= 3;
  }
  
  // 가족관계 대화 감지
  bool _detectFamilyIssue(String text) {
    final familyKeywords = [
      '가족', '부모님', '아버지', '어머니', '엄마', '아빠', '자녀', '형제', 
      '자매', '누나', '언니', '동생', '오빠', '할머니', '할아버지'
    ];
    
    int matchCount = 0;
    for (var keyword in familyKeywords) {
      if (text.contains(keyword)) {
        matchCount++;
      }
    }
    
    return matchCount >= 3;
  }
  
  // 취업/면접 필드 자동 채우기
  void _populateJobInterviewFields(String text) {
    // 회사명 추출 시도
    final companyRegex = RegExp(r'([가-힣A-Za-z]+)\s*(주식회사|회사|기업|enterprise|corp|inc)');
    final companyMatch = companyRegex.firstMatch(text);
    
    if (companyMatch != null && _contextControllers.containsKey('회사명')) {
      _contextControllers['회사명']!.text = companyMatch.group(1) ?? '';
    }
    
    // 직무/포지션 추출 시도
    final positionKeywords = ['개발자', '디자이너', '마케터', '기획자', '영업', 'PM', '매니저', '연구원'];
    for (var position in positionKeywords) {
      if (text.contains(position) && _contextControllers.containsKey('직무/포지션')) {
        _contextControllers['직무/포지션']!.text = position;
        break;
      }
    }
  }
  
  // 연애/관계 필드 자동 채우기
  void _populateRelationshipFields(String text) {
    // 관계 유형 추출 시도
    final relationKeywords = {
      '연인': ['남친', '여친', '남자친구', '여자친구', '커플', '연인'],
      '썸 관계': ['썸', '호감', '좋아하는 사람'],
      '이별 후': ['헤어짐', '이별', '헤어진'],
      '결혼 상담': ['결혼', '웨딩', '신혼', '부부'],
    };
    
    if (_contextControllers.containsKey('관계유형')) {
      for (var entry in relationKeywords.entries) {
        for (var keyword in entry.value) {
          if (text.contains(keyword)) {
            _contextControllers['관계유형']!.text = entry.key;
            return;
          }
        }
      }
    }
  }
  
  // 학업/교육 필드 자동 채우기
  void _populateAcademicFields(String text) {
    // 학교/교육기관 추출
    final institutionKeywords = ['대학교', '고등학교', '중학교', '초등학교', '학원', '교육원'];
    
    if (_contextControllers.containsKey('학교/교육기관')) {
      for (var keyword in institutionKeywords) {
        final regex = RegExp(r'([가-힣A-Za-z]+)\s*' + keyword);
        final match = regex.firstMatch(text);
        
        if (match != null) {
          _contextControllers['학교/교육기관']!.text = '${match.group(1)}$keyword';
          break;
        }
      }
    }
    
    // 과목/분야 추출
    final subjectKeywords = ['수학', '영어', '국어', '과학', '사회', '역사', '컴퓨터', '프로그래밍', '경영', '마케팅'];
    
    if (_contextControllers.containsKey('과목/분야')) {
      for (var subject in subjectKeywords) {
        if (text.contains(subject)) {
          _contextControllers['과목/분야']!.text = subject;
          break;
        }
      }
    }
  }
  
  // 가족관계 필드 자동 채우기 
  void _populateFamilyFields(String text) {
    // 가족 구성원 추출
    final familyMembers = ['부모님', '아버지', '어머니', '엄마', '아빠', '형', '누나', '언니', '오빠', '동생'];
    
    if (_contextControllers.containsKey('가족구성원')) {
      for (var member in familyMembers) {
        if (text.contains(member)) {
          _contextControllers['가족구성원']!.text = member;
          break;
        }
      }
    }
  }
  
  // 사회생활 필드 자동 채우기
  void _populateSocialFields(String text) {
    // 상황 유형 추출
    final socialKeywords = {
      '직장 동료와의 갈등': ['직장', '회사', '동료', '상사', '갈등', '트러블'],
      '친구와의 대화': ['친구', '우정', '만남', '모임'],
      '대인관계 어려움': ['인간관계', '대인관계', '소통', '어려움', '불안'],
      '사회생활 적응': ['적응', '사회생활', '피로', '스트레스'],
    };
    
    if (_contextControllers.containsKey('상황유형')) {
      for (var entry in socialKeywords.entries) {
        int matchCount = 0;
        for (var keyword in entry.value) {
          if (text.contains(keyword)) {
            matchCount++;
          }
        }
        
        if (matchCount >= 2) {
          _contextControllers['상황유형']!.text = entry.key;
          return;
        }
      }
    }
  }
  
  // 시나리오와 목표 자동 생성
  void _generateScenarioAndGoal(String text) {
    // 대화 내용이 짧으면 (200자 이하) 기본값 사용
    if (text.length < 200) {
      return;
    }
    
    String scenarioTemplate = '';
    String goalTemplate = '';
    
    // 카테고리에 따른 시나리오 및 목표 템플릿 설정
    switch (_roleplayCategory) {
      case '취업/면접':
        final company = _contextControllers['회사명']?.text ?? '회사';
        final position = _contextControllers['직무/포지션']?.text ?? '직무';
        
        scenarioTemplate = '$company ${position} 면접 상황';
        goalTemplate = '면접 질문에 효과적으로 답변하는 연습';
        break;
        
      case '연애/관계':
        final relationType = _contextControllers['관계유형']?.text ?? '관계';
        
        scenarioTemplate = '$relationType 상황에서의 대화 연습';
        goalTemplate = '원활한 소통을 통한 관계 개선';
        break;
        
      case '학업/교육':
        final institution = _contextControllers['학교/교육기관']?.text ?? '교육기관';
        final subject = _contextControllers['과목/분야']?.text ?? '과목';
        
        scenarioTemplate = '$institution의 $subject 학습 상황';
        goalTemplate = '효과적인 학습 방법 찾기';
        break;
        
      case '가족관계':
        final familyMember = _contextControllers['가족구성원']?.text ?? '가족 구성원';
        
        scenarioTemplate = '$familyMember와의 대화 상황';
        goalTemplate = '건강한 가족 관계 형성하기';
        break;
        
      case '사회생활':
        final situationType = _contextControllers['상황유형']?.text ?? '사회생활 상황';
        
        scenarioTemplate = '$situationType 상황에서의 대화';
        goalTemplate = '원활한 의사소통과 관계 개선';
        break;
    }
    
    // 시나리오와 목표 설정
    setState(() {
      if (_roleplayScenarioController.text.isEmpty) {
        _roleplayScenarioController.text = scenarioTemplate;
      }
      
      if (_roleplayGoalController.text.isEmpty) {
        _roleplayGoalController.text = goalTemplate;
      }
    });
  }
} 