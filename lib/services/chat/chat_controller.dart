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
  bool _hasNoAppointment = false; // New flag for UI state

  ChatSocketService? _socketService;
  String? _activeChatId; // This will hold the APPOINTMENT ID

  List<ChatMessage> get messages => [..._messages.reversed];
  bool get isLoading => _isLoading;
  bool get isConnected => _isConnected;
  bool get hasNoAppointment => _hasNoAppointment; // Getter for UI

  // 1. Initialize
  Future<void> initChat(String targetUserId) async {
    _isLoading = true;
    _hasNoAppointment = false;
    notifyListeners();

    try {
      final token = await getToken();
      if (token != null) {
        // STEP A: Find the Appointment ID for this user first
        final appointmentId = await _resolveAppointmentId(targetUserId, token);

        if (appointmentId != null) {
          _activeChatId = appointmentId;

          // STEP B: Connect using APPOINTMENT ID
          _connectSocket(_activeChatId!, token);

          // STEP C: Fetch History
          await _fetchHistory(_activeChatId!, token);
        } else {
          // No appointment found -> Cannot chat
          _hasNoAppointment = true;
          debugPrint('❌ No active appointment found for user $targetUserId');
        }
      }
    } catch (e) {
      debugPrint('Error initializing chat: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // NEW: Helper to find the Appointment ID based on the User ID
  Future<String?> _resolveAppointmentId(String targetUserId, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/appointments'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> list = jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;

        // Find an appointment where the target user is involved
        for (var appt in list) {
          // Handle both nested object (patient: {id: ...}) and flat (patientId: ...) formats
          final pId = appt['patientId']?.toString() ?? appt['patient']?['id']?.toString();
          final phId =
              appt['physiotherapistId']?.toString() ?? appt['physiotherapist']?['id']?.toString();

          if (pId == targetUserId || phId == targetUserId) {
            return appt['id'].toString();
          }
        }
      }
    } catch (e) {
      debugPrint('Error resolving appointment: $e');
    }
    return null;
  }

  // 2. Fetch History
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

  // 3. Connect Socket
  void _connectSocket(String chatId, String token) {
    _socketService = ChatSocketService(
      userToken: token,
      onConnectCallback: () {
        _isConnected = true;
        notifyListeners();
        // Subscribe using APPOINTMENT ID
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

  // 4. Send Message
  void sendMessage(String text) {
    if (_activeChatId == null || text.trim().isEmpty) return;

    final myId = UserDataCache().id;

    // Optimistic Update
    final tempId = DateTime.now().millisecondsSinceEpoch.toString();
    final tempMsg = ChatMessage(id: tempId, text: text, senderId: myId, timestamp: DateTime.now());

    _messages.add(tempMsg);
    notifyListeners();

    // Send to Backend
    _socketService?.sendMessage(_activeChatId!, text, myId);
  }

  @override
  void dispose() {
    _socketService?.disconnect();
    super.dispose();
  }
}
