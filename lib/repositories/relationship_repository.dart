import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:physioapp/services/auth/auth.dart';
import 'package:physioapp/utils/domain_connection.dart';
import 'package:physioapp/models/chat/connected_user.dart';

class RelationshipRepository {
  final String _baseUrl = DomainConnection().url;

  Future<Map<String, String>> getMyQrCode() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$_baseUrl/me/qrcode'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {'qrCodeLink': data['qrCodeLink'] as String};
    } else {
      throw Exception('Failed to load QR Code: ${response.statusCode}');
    }
  }

  Future<void> connectUser(String targetUserId) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$_baseUrl/api/relationships/connect'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'targetUserId': targetUserId}),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      try {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Erro ao conectar.');
      } catch (_) {
        throw Exception('Falha na conexão: ${response.statusCode}');
      }
    }
  }

  Future<List<ConnectedUser>> getConnections() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('${DomainConnection().url}/api/relationships'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> list = jsonDecode(response.body) as List<dynamic>;
      return list.map((json) => ConnectedUser.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load connections: ${response.statusCode}');
    }
  }
}


class RelationshipProvider with ChangeNotifier {
  final RelationshipRepository _repo = RelationshipRepository();

  String? _myQrCodeLink;
  bool _isLoading = false;
  String? _error;

  String? get myQrCodeLink => _myQrCodeLink;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<ConnectedUser> _connections = [];
  List<ConnectedUser> _filteredConnections = [];
  bool _isLoadingConnections = false;

  List<ConnectedUser> get connections => _filteredConnections;
  bool get isLoadingConnections => _isLoadingConnections;

  Future<void> loadMyQrCode() async {
    if (_myQrCodeLink != null) return;

    _isLoading = true;
    _error = null;

    try {
      final data = await _repo.getMyQrCode();
      _myQrCodeLink = data['qrCodeLink'];
    } catch (e) {
      _error = e.toString();
      debugPrint('Error loading QR: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> scanAndConnect(String rawCode) async {
    _isLoading = true;
    notifyListeners();

    try {
      final Uri? uri = Uri.tryParse(rawCode);

      if (uri == null || uri.scheme != 'physioapp' || uri.host != 'connect') {
        throw Exception('QR Code inválido ou de outro aplicativo.');
      }

      final String? targetId = uri.queryParameters['id'];

      if (targetId == null || targetId.isEmpty) {
        throw Exception('QR Code não contém um ID de usuário válido.');
      }

      await _repo.connectUser(targetId);

      return true;
    } catch (e) {
      _error = e.toString();
      debugPrint('Scan Error: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchConnections() async {
    _isLoadingConnections = true;
    notifyListeners();

    try {
      final data = await _repo.getConnections();
      _connections = data;
      _filteredConnections = data;
    } catch (e) {
      debugPrint('Error fetching connections: $e');
    } finally {
      _isLoadingConnections = false;
      notifyListeners();
    }
  }

  void searchConnections(String query) {
    if (query.isEmpty) {
      _filteredConnections = _connections;
    } else {
      _filteredConnections = _connections.where((user) {
        return user.fullname.toLowerCase().contains(query.toLowerCase()) ||
               user.email.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }
}
