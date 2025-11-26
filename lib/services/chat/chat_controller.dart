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
  bool _hasNoAppointment = false;

  ChatSocketService? _socketService;
  String? _activeChatId;

  List<ChatMessage> get messages => [..._messages.reversed];
  bool get isLoading => _isLoading;
  bool get isConnected => _isConnected;
  bool get hasNoAppointment => _hasNoAppointment;

  Future<void> initChat(String targetUserId) async {
    _isLoading = true;
    _hasNoAppointment = false;
    _messages = [];
    notifyListeners();

    try {
      final token = await getToken();

      debugPrint('🔑 [Chat] Using Token: $token');
      debugPrint('📨 [Chat] Header: Bearer $token');

      if (token != null) {
        final appointmentId = await _resolveAppointmentId(targetUserId, token);

        if (appointmentId != null) {
          _activeChatId = appointmentId;

          _connectSocket(_activeChatId!, token);
          await _fetchHistory(_activeChatId!, token);
        } else {
          _hasNoAppointment = true;
        }
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
      debugPrint('🔍 [Chat] Resolving Appointment for Target User: $targetUserId');

      final response = await http.get(
        Uri.parse('$_baseUrl/appointments'),
        headers: {'Authorization': 'Bearer $token'},
      );

      debugPrint('📥 [Chat] API Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final dynamic decoded = jsonDecode(utf8.decode(response.bodyBytes));
        List<dynamic> list = [];

        if (decoded is Map && decoded.containsKey('content')) {
          list = decoded['content'] as List<dynamic>;
        } else if (decoded is List) {
          list = decoded;
        }

        debugPrint('📋 [Chat] Found ${list.length} appointments in DB.');

        for (final appt in list) {
          final String apptId = appt['id']?.toString() ?? '';

          String pId = (appt['patientId'] ?? appt['patient']?['id'])?.toString() ?? '';
          String phId =
              (appt['physiotherapistId'] ?? appt['physiotherapist']?['id'])?.toString() ?? '';

          pId = pId.trim().toLowerCase();
          phId = phId.trim().toLowerCase();
          final target = targetUserId.trim().toLowerCase();

          debugPrint('   👉 Checking Appt $apptId: Pat=$pId | Phys=$phId');

          if (pId == target || phId == target) {
            debugPrint('✅ [Chat] Match Found! Appointment ID: $apptId');
            return apptId;
          }
        }
      } else {
        debugPrint('❌ [Chat] Failed to fetch appointments. Body: ${response.body}');
      }
    } catch (e) {
      debugPrint('🛑 [Chat] Error resolving appointment: $e');
    }
    debugPrint('⚠️ [Chat] No matching appointment found for this user.');
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
    if (_activeChatId == null || text.trim().isEmpty) return;

    final myId = UserDataCache().id;

    final tempMsg = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: text,
        senderId: myId,
        timestamp: DateTime.now());

    _messages.add(tempMsg);
    notifyListeners();

    _socketService?.sendMessage(_activeChatId!, text, myId);
  }

  @override
  void dispose() {
    _socketService?.disconnect();
    super.dispose();
  }
}
