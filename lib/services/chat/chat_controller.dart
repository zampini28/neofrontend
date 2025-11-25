import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:physioapp/models/chat/chat_message.dart';
import 'package:physioapp/services/auth/auth.dart';
import 'package:physioapp/services/chat_socket_service.dart';
import 'package:physioapp/utils/domain_connection.dart';

class ChatController with ChangeNotifier {
  final String _baseUrl = DomainConnection().url;

  List<ChatMessage> _messages = [];
  bool _isLoading = false;
  bool _isConnected = false;

  ChatSocketService? _socketService;
  String? _appointmentId;

  List<ChatMessage> get messages => [..._messages.reversed];
  bool get isLoading => _isLoading;
  bool get isConnected => _isConnected;

  bool _hasNoAppointment = false;
  bool get hasNoAppointment => _hasNoAppointment;

  Future<void> initChat(String targetUserId) async {
    _isLoading = true;
    _hasNoAppointment = false;
    notifyListeners();

    try {
      final token = await getToken();
      if (token == null) return;

      _appointmentId = await _resolveAppointmentId(targetUserId, token);

      if (_appointmentId != null) {
        _connectSocket(_appointmentId!, token);
        await _fetchHistory(_appointmentId!, token);
      } else {
        _hasNoAppointment = true;
        debugPrint(' -- No active appointment found for user $targetUserId');
      }
    } catch (e) {
      debugPrint('Error initializing chat: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> _resolveAppointmentId(String targetUserId, String token) async {
    try {
      debugPrint('🔍 Looking for Appointment with User: $targetUserId');

      final response = await http.get(
        Uri.parse('$_baseUrl/api/appointments'),
        headers: {'Authorization': 'Bearer $token'},
      );

      debugPrint('📥 API Response [${response.statusCode}]: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> list = jsonDecode(response.body) as List<dynamic>;

        for (final appt in list) {
          String? pId = appt['patientId']?.toString();
          String? phId = appt['physiotherapistId']?.toString();

          if (pId == null) pId = appt['patient']?['id']?.toString();
          if (phId == null) phId = appt['physiotherapist']?['id']?.toString();

          debugPrint('   - Appt ${appt['id']}: Pat=$pId | Phys=$phId');

          if (pId == targetUserId || phId == targetUserId) {
            debugPrint(' -- match found! ID: ${appt['id']}');
            return appt['id'].toString();
          }
        }
      }
    } catch (e) {
      debugPrint('Error resolving appointment: $e');
    }
    return null;
  }

  Future<void> _fetchHistory(String chatId, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/chat/history/$chatId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
        _messages = data.map((json) => ChatMessage.fromJson(json as Map<String, dynamic>)).toList();
        _messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading history: $e');
    }
  }

  void _connectSocket(String chatId, String token) {
    _socketService = ChatSocketService(
      userToken: token,
      onConnectCallback: () {
        _isConnected = true;
        notifyListeners();
        _socketService?.subscribeToChat(chatId);
      },
      onMessageReceivedCallback: (message) {
        final exists = _messages.any((m) => m.id == message.id && m.text == message.text);
        if (!exists) {
          _messages.add(message);
          notifyListeners();
        }
      },
    );
    _socketService?.connect();
  }

  void sendMessage(String text) {
    if (_appointmentId == null || text.trim().isEmpty) return;

    final myId = UserDataCache().id;

    final tempMsg = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: text,
        senderId: myId,
        timestamp: DateTime.now());

    _messages.add(tempMsg);
    notifyListeners();

    _socketService?.sendMessage(_appointmentId!, text, myId);
  }

  @override
  void dispose() {
    _socketService?.disconnect();
    super.dispose();
  }
}
