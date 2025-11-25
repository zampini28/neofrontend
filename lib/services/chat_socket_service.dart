import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:physioapp/models/chat/chat_message.dart';
import 'package:physioapp/utils/domain_connection.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class ChatSocketService {
  StompClient? _client;
  
  final Function() onConnectCallback;
  final Function(ChatMessage) onMessageReceivedCallback;
  final String userToken;

  ChatSocketService({
    required this.onConnectCallback,
    required this.onMessageReceivedCallback,
    required this.userToken,
  });

  void connect() {
    final baseUrl = DomainConnection().url; 
    final wsUrl = baseUrl.replaceFirst('http', 'ws') + '/ws';

    _client = StompClient(
      config: StompConfig(
        url: wsUrl,
        onConnect: _onConnect,

        onWebSocketError: (dynamic error) => debugPrint(' -- WS Error: $error'),

        onStompError: (StompFrame frame) {
          debugPrint(' -- Stomp Error Details:');
          debugPrint('   - Body: ${frame.body}');
          debugPrint('   - Headers: ${frame.headers}');
        },

        onDisconnect: (frame) => debugPrint('-- Disconnected'),
        
        stompConnectHeaders: {
          'Authorization': 'Bearer $userToken',
        },
        webSocketConnectHeaders: {
          'Authorization': 'Bearer $userToken',
        },
      ),
    );

    _client!.activate();
  }

  void _onConnect(StompFrame frame) {
    debugPrint('-- STOMP Connected!');
    onConnectCallback();
  }

  void subscribeToChat(String chatId) {
    final destination = '/topic/chat/$chatId';
    
    _client?.subscribe(
      destination: destination,
      callback: (StompFrame frame) {
        if (frame.body != null) {
          try {
            final dynamic data = jsonDecode(frame.body!);
            final message = ChatMessage.fromJson(data as Map<String, dynamic>);
            onMessageReceivedCallback(message);
          } catch (e) {
            debugPrint('Error parsing message: $e');
          }
        }
      },
    );
    debugPrint('Subscribed to $destination');
  }

  void sendMessage(String chatId, String text, String senderId) {
    final destination = '/app/chat/$chatId';
    
    final body = jsonEncode({
      'text': text,
      'senderId': senderId,
    });

    _client?.send(
      destination: destination,
      body: body,
      headers: {'content-type': 'application/json'},
    );
  }

  void disconnect() {
    _client?.deactivate();
  }
}
