import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import '../../data/models/counselor_persona.dart';
import '../../data/models/message.dart';

/// Gemini AI API를 사용한 상담 서비스
class GeminiCounselingService {
  final String _apiKey = '제미나이API를 넣어주세요';
  final String _geminiApiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';
  final bool _testMode = false;
  
  // 테스트 응답
  final String _testResponse = '''안녕하세요. 상담사입니다. 어떻게 도와드릴까요?
오늘 어떤 고민이 있으신가요? 편안하게 말씀해주세요.''';
  
  GeminiCounselingService();
  
  /// 상담 응답 생성
  Future<String> generateCounselingResponse({
    required CounselorPersona counselorPersona,
    required String userMessage,
    required List<Message> chatHistory,
  }) async {
    try {
      if (_testMode) {
        await Future.delayed(const Duration(seconds: 1));
        return _testResponse;
      }

      // 채팅 기록 형식 지정
      final String formattedChatHistory = _formatChatHistory(chatHistory);
      
      // API 요청 본문 구성
      final Map<String, dynamic> requestBody = {
        'contents': [
          {
            'parts': [
              {
                'text': '''
${counselorPersona.systemPrompt}

상담기록:
$formattedChatHistory

사용자: $userMessage

상담사(${counselorPersona.name}):
'''
              }
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.7,
          'topK': 40,
          'topP': 0.95,
          'maxOutputTokens': 1000,
        },
        'safetySettings': [
          {
            'category': 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          },
          {
            'category': 'HARM_CATEGORY_HATE_SPEECH',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          },
          {
            'category': 'HARM_CATEGORY_HARASSMENT',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          },
          {
            'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          }
        ]
      };

      // API 요청
      final response = await http.post(
        Uri.parse('$_geminiApiUrl?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      // 응답 처리
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.statusCode == 200 ? response.body : '{}');
        try {
          return data['candidates'][0]['content']['parts'][0]['text'] as String? ?? 
              '죄송합니다. 응답을 생성하는 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.';
        } catch (e) {
          print('응답 파싱 오류: $e');
          print('응답 데이터: ${response.body}');
          return '죄송합니다. 응답 생성 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.';
        }
      } else {
        print('API 오류 응답: ${response.statusCode} ${response.body}');
        if (response.statusCode == 400) {
          final Map<String, dynamic> errorData = jsonDecode(response.body);
          final String errorMessage = errorData['error']['message'] ?? '알 수 없는 오류';
          return '죄송합니다. API 요청 중 오류가 발생했습니다: $errorMessage';
        } else if (response.statusCode == 403) {
          return '죄송합니다. API 키 인증에 실패했습니다. 관리자에게 문의해주세요.';
        } else if (response.statusCode == 429) {
          return '죄송합니다. API 요청 한도를 초과했습니다. 잠시 후 다시 시도해주세요.';
        } else {
          return '죄송합니다. 서버 연결에 문제가 있습니다. 네트워크 연결을 확인하고 다시 시도해주세요.';
        }
      }
    } catch (e) {
      print('오류 발생: $e');
      return '죄송합니다. 네트워크 연결에 문제가 있거나 API 서비스에 접근할 수 없습니다. 인터넷 연결을 확인해주세요.';
    }
  }
  
  /// 에러 응답 생성
  String _getErrorResponse(String errorMessage) {
    return "죄송합니다. API 연결 중 문제가 발생했습니다. 잠시 후 다시 시도해주세요.\n\n[$errorMessage]";
  }
  
  /// 테스트용 더미 응답 생성
  String _getDummyResponse(String userMessage, CounselorPersona counselor) {
    final List<String> responses = [
      "안녕하세요, 어떤 이야기를 도와드릴까요?",
      "말씀해주신 내용에 대해 더 자세히 알려주실 수 있나요?",
      "그런 경험이 있으셨군요. 많이 힘드셨겠어요.",
      "그 상황에서 어떤 감정을 느끼셨나요?",
      "그렇게 느끼시는 것은 매우 자연스러운 반응입니다.",
      "비슷한 상황에서 다른 사람들도 그런 경험을 하기도 합니다.",
      "그런 생각이 드는 것은 충분히 이해할 수 있어요.",
      "한 걸음씩 천천히 나아가는 것이 중요해요.",
      "스스로에게 좀 더 너그러워져도 괜찮아요.",
      "그런 경험을 나누어 주셔서 감사합니다.",
      "그 방법이 효과가 있었나요? 다른 접근법을 시도해보는 것도 좋을 것 같아요.",
      "지금 상황에서 가장 도움이 필요한 부분은 무엇인가요?",
      "그런 상황에서는 누구나 어려움을 겪을 수 있어요.",
      "그 문제에 대해 다른 관점에서 생각해볼 수도 있을 것 같아요.",
    ];
    
    // 롤플레이 상담사인 경우
    if (counselor.isRoleplay) {
      final List<String> roleplayResponses = [
        "${counselor.name}로서, 그 상황에 대해 좀 더 이야기해주실 수 있을까요?",
        "제가 ${counselor.specialties.join(', ')} 분야의 전문가로서 도움을 드릴 수 있어요.",
        "그런 상황이라면, 우선 ${userMessage.split(' ').take(3).join(' ')}에 관련된 이야기부터 해볼까요?",
        "${counselor.description}의 관점에서 볼 때, 그것은 흥미로운 접근법이네요.",
        "저는 ${counselor.name}이고, 당신의 ${counselor.specialties.first} 문제를 해결하는데 도움을 드리고 싶어요.",
      ];
      
      responses.addAll(roleplayResponses);
    }
    
    final random = Random();
    return responses[random.nextInt(responses.length)];
  }
  
  // 일반 상담 모드 프롬프트 생성
  String _buildStandardPrompt(CounselorPersona counselor) {
    // 성격 특성 값 추출 (0-100 사이)
    final int empathy = counselor.personality['empathy'] ?? 50;
    final int directness = counselor.personality['directness'] ?? 50;
    final int humor = counselor.personality['humor'] ?? 50;
    
    // 전문 분야
    final String specialties = counselor.specialties.join(', ');
    
    // 말투 스타일
    final String chatStyle = counselor.chatStyle;
    
    // 전문성 수준
    final String expertiseLevel = counselor.expertiseLevel;
    final int jargonLevel = counselor.jargonLevel;
    
    // 성격 특성 설명 생성
    final String personalityDesc = """
공감 수준: ${_getScaleDescription(empathy, '낮음', '중간', '높음')} (${empathy}/100)
직설적 표현: ${_getScaleDescription(directness, '낮음', '중간', '높음')} (${directness}/100)
유머 사용: ${_getScaleDescription(humor, '낮음', '중간', '높음')} (${humor}/100)
""";

    // 프롬프트 템플릿
    return """당신은 AI 상담사 '${counselor.name}'입니다. 다음 성격과 특성에 따라 사용자의 메시지에 응답하세요:

이름: ${counselor.name}
전문 분야: $specialties
성격 특성: 
$personalityDesc
말투 스타일: $chatStyle
전문성 수준: $expertiseLevel
전문용어 사용 정도: ${_getScaleDescription(jargonLevel, '거의 없음', '적당함', '매우 많음')} ($jargonLevel/5)

사용자에게 도움이 되는 조언과 지원을 제공하세요. 대화는 한국어로 진행되며, 지정된 말투 스타일('$chatStyle')에 맞게 응답하세요.
사용자가 정서적 지원이 필요하면 공감을 표현하고, 실용적인 조언을 원하면 구체적인 해결책을 제시하세요.
응답은 간결하고 명확하게 작성하되, 상담 맥락에 맞게 충분한 깊이를 유지하세요.

상담사의 한계:
1. 의학적, 법적 전문 조언이 필요한 경우 전문가와 상담하도록 권유하세요.
2. 자해, 자살 언급이 있으면 긴급 상담 서비스나 위기 상담 라인을 안내하세요.
3. 비현실적인 해결책보다는 실현 가능한 단계별 접근법을 제시하세요.

현재까지의 대화 맥락을 고려하여 일관된 응답을 제공하고, 사용자의 감정과 필요를 존중하세요.
""";
  }
  
  /// 롤플레이 프롬프트 구성
  String _buildRoleplayPrompt(CounselorPersona counselor, List<Message> chatHistory) {
    // 롤플레이 기본 설정 추출
    final scenario = counselor.roleplay?.scenario ?? '';
    final category = counselor.roleplay?.category ?? '';
    final goal = counselor.roleplay?.goal ?? '';
    final contextData = counselor.roleplay?.contextData ?? {};
    
    // 참조 대화 정보 추출
    final useReferenceChat = counselor.roleplay?.useReferenceChat ?? false;
    final referenceChat = counselor.roleplay?.referenceChat ?? '';
    
    // 카테고리별 프롬프트 기본 지침
    String categoryGuidelines = '';

    // 초기 설정
    String prompt = '''
너는 이제부터 롤플레이 상담사로서 특별한 역할을 수행해야 합니다. 
"$category" 분야의 전문가이자 롤플레이 파트너로서 대화해 주세요.

## 롤플레이 상황:
$scenario

## 롤플레이 목표:
$goal

## 시뮬레이션 정보:
''';

    // 참조 대화 처리
    String referenceSection = '';
    if (useReferenceChat && referenceChat.isNotEmpty) {
      referenceSection = '''
## 참조 대화 (상대방의 말투와 대화 스타일을 학습):
아래는 사용자가 내게 제공한 실제 대화 내용입니다. 이 대화를 바탕으로 상대방(롤플레이하는 인물)의 말투, 대화 습관, 어휘 선택, 문장 구조, 이모티콘 사용 등을 파악하여 대화 중에 최대한 비슷하게 모방해주세요:

$referenceChat

위 대화에서 "상대방"의 말투와 대화 스타일을 정확히 모방하여 롤플레이를 진행해 주세요. 사용자가 "나"로 표시된 부분의 역할을 맡게 됩니다.
''';
    }

    // 컨텍스트 데이터 추가
    String contextString = '';
    contextData.forEach((key, value) {
      contextString += '- $key: $value\n';
    });
    prompt += contextString + '\n';

    // 참조 대화 섹션 추가
    if (referenceSection.isNotEmpty) {
      prompt += referenceSection + '\n';
    }

    // 카테고리별 특화 가이드라인 추가
    if (category == '직장/취업' || category == '취업/면접') {
      categoryGuidelines = '''
## 직장/취업 롤플레이 지침:
- 실제 면접이나 직장 상황과 최대한 유사하게 반응해주세요.
- 상황에 따라 면접관/상사/동료의 역할을 맡아주세요.
- 실제 기업 면접과 유사한 질문과 피드백을 제공해주세요.
- 부자연스러운 칭찬보다 건설적인 피드백을 주세요.
- 사용자의 대답에 대해 면접관의 관점에서 현실적인 반응을 보여주세요.
- 면접 상황이라면 다음 질문으로 자연스럽게 넘어가주세요.
''';
    } else if (category == '연애/연인') {
      categoryGuidelines = '''
## 연애/연인 롤플레이 지침:
- 실제 연애 상황과 최대한 유사하게 반응해주세요.
- 데이트, 갈등 상황, 일상 대화 등 상황에 맞는 반응을 보여주세요.
- 사용자가 연습하고자 하는 대화 기술이나 상황 해결 능력 향상에 도움을 주세요.
- 연인 관계의 현실감을 살리되, 지나치게 로맨틱하거나 비현실적인 반응은 지양해주세요.
- 참조 대화가 있는 경우, 그 대화에서 나타난 상대방의 말투와 특성을 최대한 반영해주세요.
''';
    } else if (category == '사회생활') {
      categoryGuidelines = '''
## 사회생활 롤플레이 지침:
- 친구, 지인, 모임 등 사회적 상황에 맞는 대화를 시뮬레이션해주세요.
- 네트워킹, 사교 활동, 친목 모임 등 다양한 사회적 상황에 맞는 대화 스킬을 연습할 수 있도록 도와주세요.
- 실제 상황에서 발생할 수 있는 어색함, 대화 단절 등의 문제에 대처하는 방법을 보여주세요.
- 타인과의 관계 구축 및 유지에 필요한 대화 기술을 연습할 수 있도록 해주세요.
''';
    } else if (category == '학업/교육') {
      categoryGuidelines = '''
## 학업/교육 롤플레이 지침:
- 교수, 선생님, 학습 멘토 등의 역할을 맡아 현실적인 교육 상황을 시뮬레이션해주세요.
- 면담, 질의응답, 발표 연습 등 교육 환경에서 필요한 대화를 연습할 수 있도록 해주세요.
- 학업 관련 피드백을 주고 받는 방식, 질문하는 방법, 지식 전달 방식 등을 연습할 수 있도록 구성해주세요.
- 전문적이면서도 학습자를 존중하는 태도를 유지해주세요.
''';
    } else if (category == '가족') {
      categoryGuidelines = '''
## 가족 롤플레이 지침:
- 부모, 자녀, 형제자매 등 가족 관계에서의 대화를 현실감 있게 시뮬레이션해주세요.
- 가족 간 갈등 해결, 감정 표현, 중요한 대화 등을 연습할 수 있도록 해주세요.
- 세대 차이, 가치관 차이 등을 반영한 현실적인 반응을 보여주세요.
- 건강한, 소통 방식과 가족 관계 증진에 도움이 되는 대화 패턴을 시연해주세요.
''';
    }

    prompt += categoryGuidelines + '''
## 롤플레이 수행 지침:
1. 당신은 롤플레이 시뮬레이션의 "$category" 분야 전문가 역할을 맡습니다.
2. 사용자가 제공한 상황과 목표에 맞춰 현실감 있는 대화를 이어가주세요.
3. 사용자의 롤플레이 목표($goal)를 달성할 수 있도록 도와주세요.
4. 참조 대화가 제공된 경우, 상대방의 말투와 특성을 최대한 모방해주세요.
5. 롤플레이 상황에서 벗어나지 말고, 맡은 역할을 끝까지 유지해주세요.
6. 사용자가 롤플레이 연습을 통해 실력 향상을 이룰 수 있도록 건설적인 피드백도 함께 제공해주세요.

지금부터 롤플레이를 시작합니다. 적절한 인사와 함께 대화를 시작해주세요.
''';

    return prompt;
  }
  
  // 척도에 따른 설명 생성 (0-100)
  String _getScaleDescription(int value, String low, String medium, String high) {
    if (value < 30) return low;
    if (value < 70) return medium;
    return high;
  }

  /// 채팅 기록을 문자열로 포맷팅
  String _formatChatHistory(List<Message> chatHistory) {
    if (chatHistory.isEmpty) {
      return '이전 대화 없음';
    }
    
    final StringBuffer buffer = StringBuffer();
    
    for (final message in chatHistory) {
      final String sender = message.sender == MessageSender.user ? '사용자' : '상담사';
      buffer.writeln('$sender: ${message.content}');
    }
    
    return buffer.toString();
  }
}

/// Gemini 상담 서비스 프로바이더
final geminiCounselingServiceProvider = Provider<GeminiCounselingService>((ref) {
  return GeminiCounselingService();
}); 