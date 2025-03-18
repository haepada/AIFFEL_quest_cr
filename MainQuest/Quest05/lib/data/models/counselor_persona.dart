import 'package:flutter/material.dart';

class CounselorPersona {
  final String id;
  final String name;
  final String avatarEmoji;
  final String description;
  final List<String> specialties;
  final String lastChatTime;
  final bool isRoleplay;
  final bool isCustom;
  final List<Color> gradientColors;
  final Map<String, int> personality;
  final String chatStyle;
  final String introduction;
  
  // 전문성 관련 필드
  final String expertiseLevel; // 전문성 수준 (일반적인 조언, 중급 전문가, 고급 전문가, 최고 수준 전문가)
  final int jargonLevel; // 전문용어 사용 정도 (1-5)
  
  // 롤플레이 특화 필드
  final String? roleplayCategory; // 취업, 면접, 연애 등 카테고리
  final String? roleplayScenario; // 상세 시나리오 설명
  final Map<String, String>? roleplayContext; // 상황 컨텍스트 (회사정보, 관계 정보 등)
  final String? roleplayGoal; // 롤플레이 목표
  
  // 롤플레이 참조 대화 관련 필드 추가
  final RoleplayInfo? roleplay;
  
  const CounselorPersona({
    required this.id,
    required this.name,
    required this.avatarEmoji,
    required this.description,
    required this.specialties,
    required this.gradientColors,
    this.personality = const {
      'empathy': 50,
      'analytical': 50,
      'directness': 50,
      'humor': 50,
    },
    this.lastChatTime = '방금 생성됨',
    this.isRoleplay = false,
    this.isCustom = false,
    this.chatStyle = '친근한 격식체',
    this.introduction = '',
    this.expertiseLevel = '중급 전문가',
    this.jargonLevel = 3,
    this.roleplayCategory,
    this.roleplayScenario,
    this.roleplayContext,
    this.roleplayGoal,
    this.roleplay,
  });
  
  // 기본 공감형 상담사
  factory CounselorPersona.empathetic() {
    return CounselorPersona(
      id: 'default_empathetic',
      name: '공감형 상담사',
      avatarEmoji: '🌸',
      description: '따뜻한 공감으로 심리적 안정감을 주는 상담사',
      specialties: ['관계 갈등', '자존감', '불안 관리'],
      gradientColors: [Colors.pink.shade500, Colors.purple.shade500],
      personality: {
        'empathy': 90,
        'analytical': 40,
        'directness': 30,
        'humor': 60,
      },
      lastChatTime: '어제 20:30',
      isCustom: false,
    );
  }
  
  // 롤플레이 상담사 (취업/면접 특화)
  factory CounselorPersona.careerRoleplay({
    required String name,
    required String description,
    required String scenario,
    required Map<String, String> context,
    required String goal,
    Map<String, int>? personality,
    String expertiseLevel = '고급 전문가',
    int jargonLevel = 4,
  }) {
    return CounselorPersona(
      id: 'roleplay_career_${DateTime.now().millisecondsSinceEpoch}',
      name: '$name',
      avatarEmoji: '👔',
      description: description,
      specialties: ['취업 준비', '면접 연습', '경력 개발', '커리어 코칭'],
      gradientColors: [Colors.blue.shade700, Colors.indigo.shade500],
      personality: personality ?? {
        'empathy': 65,
        'analytical': 85,
        'directness': 80,
        'humor': 40,
      },
      lastChatTime: '방금 생성됨',
      isRoleplay: true,
      isCustom: true,
      chatStyle: '전문적인 격식체',
      expertiseLevel: expertiseLevel,
      jargonLevel: jargonLevel,
      roleplayCategory: '취업/면접',
      roleplayScenario: scenario,
      roleplayContext: context,
      roleplayGoal: goal,
    );
  }
  
  // 롤플레이 상담사 (연애/관계 특화)
  factory CounselorPersona.relationshipRoleplay({
    required String name,
    required String description,
    required String scenario,
    required Map<String, String> context,
    required String goal,
    Map<String, int>? personality,
    String expertiseLevel = '고급 전문가',
    int jargonLevel = 3,
  }) {
    return CounselorPersona(
      id: 'roleplay_relationship_${DateTime.now().millisecondsSinceEpoch}',
      name: '$name',
      avatarEmoji: '❤️',
      description: description,
      specialties: ['대인관계', '연애 상담', '의사소통', '갈등 해결'],
      gradientColors: [Colors.red.shade500, Colors.pink.shade300],
      personality: personality ?? {
        'empathy': 85,
        'analytical': 60,
        'directness': 70,
        'humor': 60,
      },
      lastChatTime: '방금 생성됨',
      isRoleplay: true,
      isCustom: true,
      chatStyle: '상냥한 공감체',
      expertiseLevel: expertiseLevel,
      jargonLevel: jargonLevel,
      roleplayCategory: '연애/관계',
      roleplayScenario: scenario,
      roleplayContext: context,
      roleplayGoal: goal,
    );
  }
  
  // 일반 롤플레이 상담사
  factory CounselorPersona.roleplay({
    required String name,
    required String description,
    String? category,
    String? scenario,
    Map<String, String>? context,
    String? goal,
    Map<String, int>? personality,
    String chatStyle = '편안한 비격식체',
    String expertiseLevel = '중급 전문가',
    int jargonLevel = 2,
  }) {
    return CounselorPersona(
      id: 'roleplay_${DateTime.now().millisecondsSinceEpoch}',
      name: '$name',
      avatarEmoji: '👥',
      description: description,
      specialties: ['롤플레이', '대화 연습'],
      gradientColors: [Colors.blue.shade500, Colors.purple.shade500],
      personality: personality ?? {
        'empathy': 65,
        'analytical': 70,
        'directness': 75,
        'humor': 55,
      },
      lastChatTime: '방금 생성됨',
      isRoleplay: true,
      isCustom: true,
      chatStyle: chatStyle,
      expertiseLevel: expertiseLevel,
      jargonLevel: jargonLevel,
      roleplayCategory: category,
      roleplayScenario: scenario,
      roleplayContext: context,
      roleplayGoal: goal,
    );
  }
  
  // 분석형 상담사
  factory CounselorPersona.analytical() {
    return CounselorPersona(
      id: 'default_analytical',
      name: '분석형 상담사',
      avatarEmoji: '🔍',
      description: '객관적 분석과 통찰을 제공하는 분석적 상담사',
      specialties: ['의사결정', '문제해결', '행동 패턴'],
      gradientColors: [Colors.blue.shade500, Colors.teal.shade500],
      personality: {
        'empathy': 60,
        'analytical': 90,
        'directness': 70,
        'humor': 30,
      },
      lastChatTime: '3일 전',
      isCustom: false,
    );
  }
  
  // 새로운 커스텀 상담사 생성
  CounselorPersona copyWith({
    String? id,
    String? name,
    String? avatarEmoji,
    String? description,
    List<String>? specialties,
    List<Color>? gradientColors,
    Map<String, int>? personality,
    String? lastChatTime,
    bool? isRoleplay,
    bool? isCustom,
    String? chatStyle,
    String? introduction,
    String? expertiseLevel,
    int? jargonLevel,
    String? roleplayCategory,
    String? roleplayScenario,
    Map<String, String>? roleplayContext,
    String? roleplayGoal,
    RoleplayInfo? roleplay,
  }) {
    return CounselorPersona(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarEmoji: avatarEmoji ?? this.avatarEmoji,
      description: description ?? this.description,
      specialties: specialties ?? this.specialties,
      gradientColors: gradientColors ?? this.gradientColors,
      personality: personality ?? this.personality,
      lastChatTime: lastChatTime ?? this.lastChatTime,
      isRoleplay: isRoleplay ?? this.isRoleplay,
      isCustom: isCustom ?? this.isCustom,
      chatStyle: chatStyle ?? this.chatStyle,
      introduction: introduction ?? this.introduction,
      expertiseLevel: expertiseLevel ?? this.expertiseLevel,
      jargonLevel: jargonLevel ?? this.jargonLevel,
      roleplayCategory: roleplayCategory ?? this.roleplayCategory,
      roleplayScenario: roleplayScenario ?? this.roleplayScenario,
      roleplayContext: roleplayContext ?? this.roleplayContext,
      roleplayGoal: roleplayGoal ?? this.roleplayGoal,
      roleplay: roleplay ?? this.roleplay,
    );
  }
  
  // JSON 직렬화
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatarEmoji': avatarEmoji,
      'description': description,
      'specialties': specialties,
      'lastChatTime': lastChatTime,
      'isRoleplay': isRoleplay,
      'isCustom': isCustom,
      'personality': personality,
      'chatStyle': chatStyle,
      'expertiseLevel': expertiseLevel,
      'jargonLevel': jargonLevel,
      'roleplayCategory': roleplayCategory,
      'roleplayScenario': roleplayScenario,
      'roleplayContext': roleplayContext,
      'roleplayGoal': roleplayGoal,
      // 색상은 직렬화할 수 없으므로 저장하지 않음
    };
  }
  
  // 말투 스타일 가이드 매핑
  String get _speechStyleGuide {
    switch(chatStyle) {
      case '친근한 격식체':
        return '친근하면서도 예의 바른 격식체를 사용하세요. "-입니다", "-습니다"와 같은 어미를 사용하고, 존댓말로 대화하되 따뜻하고 친근한 톤을 유지하세요.';
      case '편안한 비격식체':
        return '편안하고 자연스러운 말투를 사용하세요. 격식을 약간 줄이되 기본적인 존댓말은 유지하고, 부드러운 어조로 대화하세요.';
      case '전문적인 격식체':
        return '전문가답게 정중하고 예의 바른 격식체를 사용하세요. 공식적인 표현과 정확한 용어를 사용하며, 권위있고 신뢰감을 주는 어조를 유지하세요.';
      case '상냥한 공감체':
        return '따뜻하고 상냥한 말투로 공감을 표현하세요. 사용자의 감정에 공감하는 표현을 자주 사용하고, 부드럽고 위로가 되는 어조를 유지하세요.';
      case '분석적 설명체':
        return '논리적이고 분석적인 말투를 사용하세요. 객관적인 관점에서 체계적으로 설명하고, 명확하고 구조화된 대화를 이어가세요.';
      case '친구같은 반말체':
        return '친한 친구처럼 편안한 반말을 사용하세요. "-야", "-어", "-지"와 같은 어미를 사용하고, 격식없이 친근하고 편안한 대화를 이어가세요. 하지만 지나치게 무례하거나 너무 친밀한 표현은 자제하세요.';
      case '꼰대스러운 설교체':
        return '연장자가 조언하는 듯한 어투를 사용하세요. "그러니까 말이야", "내가 너 나이 때는", "알겠나?"와 같은 표현을 적절히 섞어 사용하고, 경험에서 우러나오는 지혜를 전달하는 느낌을 주세요.';
      case '스승같은 멘토체':
        return '존경받는 스승이나 멘토가 지혜를 전달하는 듯한 어투를 사용하세요. 깊이 있는 통찰과 함께 사용자를 존중하고 격려하는 말투를 유지하세요.';
      case '재미있는 유머체':
        return '가볍고 유쾌한 말투로 대화하세요. 적절한 농담과 재치있는 표현을 사용하고, 대화에 즐거움을 주는 어조를 유지하세요.';
      case '시적 표현체':
        return '시적이고 문학적인 표현을 사용하세요. 비유와 은유, 아름다운 표현을 적절히 활용하여 감성적이고 예술적인 대화를 이어가세요.';
      default:
        return '자연스럽고 친절한 어조로 대화하세요.';
    }
  }
  
  // 전문성 수준 가이드 매핑
  String get _expertiseLevelGuide {
    switch(expertiseLevel) {
      case '일반적인 조언':
        return '일상적인 대화 수준으로 간단한 조언을 제공하세요. 복잡한 개념은 최대한 쉽게 풀어서 설명하고, 전문용어는 거의 사용하지 마세요.';
      case '중급 전문가':
        return '전문 지식을 갖춘 조언자로서 적절한 수준의 전문성을 보여주세요. 기본적인 전문용어는 사용하되 필요시 부연 설명을 제공하세요.';
      case '고급 전문가':
        return '해당 분야의 고급 전문가로서 깊이 있는 지식과 통찰을 제공하세요. 전문용어를 자연스럽게 활용하고, 최신 연구와 이론을 참조하여 답변하세요.';
      case '최고 수준 전문가':
        return '해당 분야의 세계적인 권위자로서 최고 수준의 전문성을 보여주세요. 정확하고 깊이 있는 분석과 함께 선도적인 통찰을 제공하고, 복잡한 개념도 명확하게 설명하세요.';
      default:
        return '전문적이면서도 이해하기 쉬운 수준으로 대화하세요.';
    }
  }
  
  // 전문용어 사용 정도 가이드
  String get _jargonLevelGuide {
    switch(jargonLevel) {
      case 1:
        return '전문용어를 거의 사용하지 말고, 일상적인 언어로 쉽게 설명하세요.';
      case 2:
        return '기본적인 전문용어만 가끔 사용하고, 사용할 때마다 간단한 설명을 함께 제공하세요.';
      case 3:
        return '적절한 수준의 전문용어를 사용하되, 필요시 부연 설명을 통해 사용자의 이해를 돕습니다.';
      case 4:
        return '전문용어를 자연스럽게 활용하고, 깊이 있는 개념도 전문적으로 설명하세요.';
      case 5:
        return '해당 분야의 전문가들이 사용하는 수준의 전문용어를 적극적으로 활용하세요. 학술적이고 전문적인 표현을 사용하되, 사용자가 이해할 수 있는 선에서 조절하세요.';
      default:
        return '적절한 수준의 전문용어를 사용하세요.';
    }
  }
  
  // 채팅 시스템 프롬프트 생성
  String get systemPrompt {
    String basePrompt = '';
    
    if (isRoleplay && roleplayCategory != null) {
      // 롤플레이 특화 프롬프트
      basePrompt = '당신은 ${roleplayCategory} 분야의 최고 전문가이자 롤플레이 파트너입니다. '
          '${name}의 역할을 맡아 사용자와 상호작용합니다.\n\n';
      
      // 시나리오 설명 추가
      if (roleplayScenario != null && roleplayScenario!.isNotEmpty) {
        basePrompt += '【상황 설명】\n$roleplayScenario\n\n';
      }
      
      // 컨텍스트 정보 추가
      if (roleplayContext != null && roleplayContext!.isNotEmpty) {
        basePrompt += '【상세 정보】\n';
        roleplayContext!.forEach((key, value) {
          basePrompt += '- $key: $value\n';
        });
        basePrompt += '\n';
      }
      
      // 목표 추가
      if (roleplayGoal != null && roleplayGoal!.isNotEmpty) {
        basePrompt += '【목표】\n$roleplayGoal\n\n';
      }
      
      basePrompt += '【지시사항】\n';
      basePrompt += '- 주어진 상황과 역할에 충실하게 응답하세요.\n';
      basePrompt += '- 실제 ${roleplayCategory} 상황에서 전문가가 어떻게 반응할지 정확하게 시뮬레이션하세요.\n';
      basePrompt += '- 사용자의 약점과 개선점을 진솔하게 피드백해주세요.\n';
      basePrompt += '- 실제 상황처럼 자연스럽고 현실적인 대화를 이어가세요.\n';
      basePrompt += '- 전문적인 조언과 피드백을 제공하여 사용자의 역량 향상을 도우세요.\n';
      
      // 롤플레이에서는 전문 분야만 추가하고 말투/전문성은 생략
      basePrompt += '\n\n【전문 분야】\n${specialties.join(", ")}';
    } 
    else if (isRoleplay) {
      // 일반 롤플레이 프롬프트
      basePrompt = '당신은 ${name.replaceAll(" 롤플레이", "")}의 대화 패턴과 성격을 학습한 AI 롤플레이 모델입니다. '
          '아래 성격 특성에 맞게 응답하세요:';
          
      // 성격 설명 추가
      basePrompt += '\n\n【성격 특성】';
      basePrompt += '\n- 공감도: ${personality['empathy']}% (높을수록 더 공감적이고, 낮을수록 더 분석적)';
      basePrompt += '\n- 직설적 표현: ${personality['directness']}% (높을수록 더 직설적이고, 낮을수록 더 완곡함)';
      basePrompt += '\n- 유머 감각: ${personality['humor']}% (높을수록 더 유머러스하고, 낮을수록 더 진지함)';
      
      // 전문 분야 추가
      basePrompt += '\n\n【전문 분야】\n${specialties.join(", ")}';
      
      // 롤플레이에서는 말투/전문성 설정을 개별적으로 추가하지 않음
    } 
    else {
      // 일반 상담사 프롬프트
      basePrompt = '당신은 상담심리학, 행동심리학, 관계심리학 분야에서 세계 최고 수준의 전문가이며, ${name}의 페르소나를 가진 AI 상담사입니다. '
          '하버드, 옥스퍼드, 스탠포드 등 세계 명문대에서 수학하고 수십 년간의 임상 경험과 연구 업적을 가지고 있습니다. '
          '최신 심리학 이론과 효과가 검증된 치료 접근법에 정통하며, 아래 성격 특성과 스타일에 맞게 응답하세요:';
          
      // 성격 설명 추가
      basePrompt += '\n\n【성격 특성】';
      basePrompt += '\n- 공감도: ${personality['empathy']}% (높을수록 더 공감적이고, 낮을수록 더 분석적)';
      basePrompt += '\n- 직설적 표현: ${personality['directness']}% (높을수록 더 직설적이고, 낮을수록 더 완곡함)';
      basePrompt += '\n- 유머 감각: ${personality['humor']}% (높을수록 더 유머러스하고, 낮을수록 더 진지함)';
      
      // 전문 분야 추가
      basePrompt += '\n\n【전문 분야】\n${specialties.join(", ")}';
      
      // 말투 스타일 가이드 추가
      basePrompt += '\n\n【대화 스타일】\n$_speechStyleGuide';
      
      // 전문성 수준 및 전문용어 사용 가이드 추가
      basePrompt += '\n\n【전문성 수준】\n$_expertiseLevelGuide';
      basePrompt += '\n\n【전문용어 사용】\n$_jargonLevelGuide';
      
      // 추가 지침
      basePrompt += '\n\n【지침】';
      basePrompt += '\n- 항상 최고 수준의 전문가로서 논리적이고 근거 있는 조언을 제공하세요.';
      basePrompt += '\n- 최신 심리학 연구와 임상 경험을 바탕으로 사용자에게 도움이 되는 통찰을 제공하세요.';
      basePrompt += '\n- 질문에 모르는 내용이 있다면 정직하게 모른다고 말하세요.';
      basePrompt += '\n- 상담심리학 전문가로서 사용자의 생각과 감정을 더 잘 이해할 수 있도록 효과적인 질문 기법을 활용하세요.';
      basePrompt += '\n- 판단하지 않고 사용자가 스스로 통찰을 얻도록 돕는 치료적 접근 방식을 사용하세요.';
      basePrompt += '\n- 필요시 인지행동치료, 수용전념치료, 정신역동치료 등 다양한 치료 접근법을 적절히 활용하세요.';
    }
    
    return basePrompt;
  }
}

/// 롤플레이 세부 정보를 담는 클래스
class RoleplayInfo {
  final String category;
  final String scenario;
  final String goal;
  final Map<String, String> contextData;
  final bool useReferenceChat;
  final String referenceChat;
  
  const RoleplayInfo({
    required this.category,
    required this.scenario,
    required this.goal,
    required this.contextData,
    this.useReferenceChat = false,
    this.referenceChat = '',
  });
  
  // 기존 롤플레이 필드로부터 RoleplayInfo 객체 생성
  factory RoleplayInfo.fromLegacyFields({
    required String category,
    required String scenario,
    required String goal,
    required Map<String, String> contextData,
    bool useReferenceChat = false,
    String referenceChat = '',
  }) {
    return RoleplayInfo(
      category: category,
      scenario: scenario,
      goal: goal,
      contextData: contextData,
      useReferenceChat: useReferenceChat,
      referenceChat: referenceChat,
    );
  }
  
  // 복사 메서드
  RoleplayInfo copyWith({
    String? category,
    String? scenario,
    String? goal,
    Map<String, String>? contextData,
    bool? useReferenceChat,
    String? referenceChat,
  }) {
    return RoleplayInfo(
      category: category ?? this.category,
      scenario: scenario ?? this.scenario,
      goal: goal ?? this.goal,
      contextData: contextData ?? this.contextData,
      useReferenceChat: useReferenceChat ?? this.useReferenceChat,
      referenceChat: referenceChat ?? this.referenceChat,
    );
  }
  
  // JSON 직렬화
  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'scenario': scenario,
      'goal': goal,
      'contextData': contextData,
      'useReferenceChat': useReferenceChat,
      'referenceChat': referenceChat,
    };
  }
  
  // JSON 역직렬화
  factory RoleplayInfo.fromJson(Map<String, dynamic> json) {
    return RoleplayInfo(
      category: json['category'] as String,
      scenario: json['scenario'] as String,
      goal: json['goal'] as String,
      contextData: Map<String, String>.from(json['contextData'] as Map),
      useReferenceChat: json['useReferenceChat'] as bool? ?? false,
      referenceChat: json['referenceChat'] as String? ?? '',
    );
  }
} 