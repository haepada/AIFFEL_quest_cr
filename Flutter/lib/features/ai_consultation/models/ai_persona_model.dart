import 'package:flutter/material.dart';

class AIPersonaModel {
  final String id;
  final String name;
  final String avatar;
  final List<Color> gradient;
  final String persona;
  final String description;
  final String style;
  final String defaultNickname;
  final String initialGreeting;

  AIPersonaModel({
    required this.id,
    required this.name,
    required this.avatar,
    required this.gradient,
    required this.persona,
    required this.description,
    required this.style,
    required this.defaultNickname,
    required this.initialGreeting,
  });

  // 객체를 맵으로 변환 (JSON 직렬화를 위해)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'persona': persona,
      'description': description,
      'style': style,
      'defaultNickname': defaultNickname,
      'initialGreeting': initialGreeting,
    };
  }
}