import 'dart:convert';

import 'package:physioapp/models/chat_message.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatSocketService {
  StompClient? stompClient;

  final Function() onConnectCallback;

  final Function(ChatMessage) onMessageReceivedCallback;

  final String _userToken;

  ChatSocketService({
    required this.onConnectCallback,
    required this.onMessageReceivedCallback,
    required String userToken,
  }) : _userToken = userToken;

  void connect() {
    final String baseUrl = dotenv.env['BASE_URL'] ?? 'localhost:8080';
    final String socketUrl = 'ws://$baseUrl/ws';

    stompClient = StompClient(
      config: StompConfig(
        url: socketUrl,
        onConnect: _onConnect,
        onWebSocketError: (dynamic error) => print(error),

        stompConnectHeaders: {
          'Authorization': 'Bearer $_userToken'
        },
      ),
    );

    stompClient!.activate();
  }

  void _onConnect(StompFrame frame) {
    onConnectCallback();
  }

  void subscribeToChat(String chatRoomId) {
    final String destination = '/topic/chat/$chatRoomId';

    stompClient?.subscribe(
      destination: destination,
      callback: (frame) {
        if (frame.body != null) {
          final Map<String, dynamic> data = json.decode(frame.body!) as Map<String, dynamic>;
          final message = ChatMessage(
            messageId: data['messageId'] as String,
            text: data['text'] as String,
            senderId: data['senderId'] as String,
            timestamp: DateTime.parse(data['timestamp'] as String),
          );

          onMessageReceivedCallback(message);
        }
      },
    );
  }

  void sendMessage(String chatRoomId, String messageText, String senderId) {
    final String destination = '/app/chat/$chatRoomId';

    final body = json.encode({
      'text': messageText,
      'senderId': senderId,
      'timestamp': DateTime.now().toIso8601String(),
    });

    stompClient?.send(
      destination: destination,
      body: body,
    );
  }

  void disconnect() {
    stompClient?.deactivate();
  }
}
