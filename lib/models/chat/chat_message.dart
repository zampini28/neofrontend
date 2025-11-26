import 'dart:convert';
import 'package:flutter/material.dart';

String prettier(Map<String, dynamic> jsonMap) =>
    const JsonEncoder.withIndent('  ').convert(jsonMap);

class ChatMessage {
  final String id;
  final String text;
  final String senderId;
  final DateTime timestamp;
  final bool isRead;

  ChatMessage({
    required this.id,
    required this.text,
    required this.senderId,
    required this.timestamp,
    this.isRead = false,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {

    debugPrint('--------------------');
    debugPrint(prettier(json));
    debugPrint('--------------------');
    
    return ChatMessage(
      id: json['messageId']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      text: json['text']?.toString() ?? '',
      senderId: json['senderId']?.toString() ?? '',
      timestamp: json['timestamp'] != null 
          ? DateTime.parse(json['timestamp'] as String) 
          : DateTime.now(),
      //isRead: json['isRead'] as bool ?? false, // TODO: isRead not returning (see chat_socket_service.dart)
      isRead: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messageId': id,
      'text': text,
      'senderId': senderId,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
