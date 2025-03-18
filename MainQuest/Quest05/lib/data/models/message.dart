import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

/// 메시지 발신자 유형
enum MessageSender {
  user,
  counselor,
  system,
}

/// 채팅 메시지 모델
class Message {
  final String id;
  final String content;
  final DateTime timestamp;
  final MessageSender sender;
  final bool isError;
  final bool isSystem;
  final bool isLoading;

  Message({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.sender,
    this.isError = false,
    this.isSystem = false,
    this.isLoading = false,
  });

  /// 사용자 메시지 생성 팩토리
  factory Message.fromUser({required String content}) {
    return Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      timestamp: DateTime.now(),
      sender: MessageSender.user,
      isSystem: false,
      isError: false,
    );
  }

  /// 상담사 메시지 생성 팩토리
  factory Message.fromCounselor({required String content}) {
    return Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      timestamp: DateTime.now(),
      sender: MessageSender.counselor,
      isSystem: false,
      isError: false,
    );
  }

  /// 시스템 메시지 생성 팩토리
  factory Message.fromSystem({required String content, bool isLoading = false}) {
    return Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      timestamp: DateTime.now(),
      sender: MessageSender.system,
      isSystem: true,
      isError: false,
      isLoading: isLoading,
    );
  }

  /// 오류 메시지 생성 팩토리
  factory Message.error({required String content}) {
    return Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      timestamp: DateTime.now(),
      sender: MessageSender.system,
      isSystem: true,
      isError: true,
    );
  }

  /// JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'sender': sender.toString().split('.').last,
      'isError': isError,
      'isSystem': isSystem,
      'isLoading': isLoading,
    };
  }

  /// JSON에서 메시지 복원
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
      sender: _senderFromString(json['sender']),
      isError: json['isError'] ?? false,
      isSystem: json['isSystem'] ?? false,
      isLoading: json['isLoading'] ?? false,
    );
  }

  /// 메시지 복사본 생성
  Message copyWith({
    String? id,
    String? content,
    DateTime? timestamp,
    MessageSender? sender,
    bool? isError,
    bool? isSystem,
    bool? isLoading,
  }) {
    return Message(
      id: id ?? this.id,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      sender: sender ?? this.sender,
      isError: isError ?? this.isError,
      isSystem: isSystem ?? this.isSystem,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  /// 메시지 ID 생성
  static String _generateId() {
    final random = Random();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomPart = random.nextInt(10000);
    return '$timestamp-$randomPart';
  }

  /// 타임스탬프 포맷팅
  String get formattedTime {
    final formatter = DateFormat('HH:mm');
    return formatter.format(timestamp);
  }

  /// 메시지가 오늘 전송되었는지 확인
  bool get isSentToday {
    final now = DateTime.now();
    return timestamp.year == now.year && 
           timestamp.month == now.month && 
           timestamp.day == now.day;
  }

  /// sender 문자열을 enum으로 변환
  static MessageSender _senderFromString(String sender) {
    switch (sender) {
      case 'user':
        return MessageSender.user;
      case 'counselor':
        return MessageSender.counselor;
      case 'system':
        return MessageSender.system;
      default:
        return MessageSender.system;
    }
  }
} 