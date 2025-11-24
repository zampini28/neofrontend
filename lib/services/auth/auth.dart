import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:physioapp/utils/domain_connection.dart';
import 'package:shared_preferences/shared_preferences.dart';

final String _base = DomainConnection().url;

String prettier(Map<String, dynamic> jsonMap) =>
    const JsonEncoder.withIndent('  ').convert(jsonMap);

Future<void> saveToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('jwt_token', token);
}

Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('jwt_token');
}

Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('jwt_token');
}

Future<bool> authRegister({
  required String imageProfile,
  required String fullname,
  required String email,
  required String password,
  required String userType,
  String? crefito,
  bool? occupational,
}) async {
  final body = {
    'profile_image': imageProfile,
    'fullname': fullname,
    'email': email,
    'password': password,
    'user_type': userType,
    'crefito': crefito,
    'occupational': occupational,
  };

  print(' -- send register body: ${prettier(body)}');

  final response = await http.post(
    Uri.parse('$_base/auth/register'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(body),
  );

  print(' -- register status_code: ${response.statusCode}');

  return response.statusCode == 201;
}

Future<bool> authLogin({
  required String email,
  required String password,
}) async {
  final body = {
    'email': email,
    'password': password,
  };

  debugPrint(' -- send login body: ${prettier(body)}');

  final response = await http.post(
    Uri.parse('$_base/auth/login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(body),
  );

  if (response.statusCode != 200) return false;

  final decoded = jsonDecode(response.body);
  final token = decoded['token'];

  await saveToken(token as String);

  await UserDataCache().initialize();

  return true;
}

Future<http.Response?> getProfile() async {
  debugPrint(' -- Attempting to get user profile');
  final token = await getToken();
  if (token == null) {
    debugPrint(' -- No token found for getProfile');
    return null;
  }
  debugPrint(' -- Token found, fetching profile from $_base/me using $token...');

  final response = await http.get(
    Uri.parse('$_base/me'),
    headers: {'Authorization': 'Bearer $token'},
  );

  debugPrint(' -- getProfile status_code: ${response.statusCode}');
  debugPrint(' -- getProfile body: ${response.body}');

  return response;
}

Future<http.Response?> updateProfile({
  required String userId,
  String? fullname,
  String? email,
  String? password,
}) async {
  final token = await getToken();
  if (token == null) return null;

  final body = jsonEncode({
    'fullname': fullname,
    'email': email,
    'password': password,
  });

  return http.put(
    Uri.parse('$_base/users/$userId'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: body,
  );
}

Future<String?> fetchProfileImage() async {
  final token = await getToken();
  if (token == null) return null;

  final url = Uri.parse('$_base/me/profile-image');

  try {
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['profile_image'] as String?;
    }
  } catch (e) {
    debugPrint('Error fetching image: $e');
  }
  return null;
}

Future<void> updateProfileImage(Uint8List image) async {
  final token = await getToken();
  if (token == null) return;

  final url = Uri.parse('$_base/me/profile-image');

  final body = {'profile_image': base64Encode(image)};

  try {
    final response = await http.put(
      url,
      headers: {'Authorization': 'Bearer $token'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 204) {
      debugPrint(' --- update profile image successfully');
    }
  } catch (e) {
    debugPrint('Error updating profile image: $e');
  }
}

Future<void> updateUserFullname({required String fullname}) async {
  final token = await getToken();
  if (token == null) return;

  final url = Uri.parse('$_base/me/fullname');

  final body = {'fullname': fullname};

  try {
    final response = await http.put(
      url,
      headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      debugPrint(' --- update user fullname successfully');
      final data = jsonDecode(response.body);
      final token = data['token'] as String;
      await saveToken(token);
      UserDataCache().initialize();
    }
  } catch (e) {
    debugPrint('Error updating user fullname: $e');
  }
}

Future<void> updateUserEmail({required String email}) async {
  final token = await getToken();
  if (token == null) return;

  final url = Uri.parse('$_base/me/email');

  final body = {'email': email};

  try {
    final response = await http.put(
      url,
      headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      debugPrint(' --- update user email successfully');
      final data = jsonDecode(response.body);
      final token = data['token'] as String;
      await saveToken(token);
      UserDataCache().initialize();
    }
  } catch (e) {
    debugPrint('Error updating user email: $e');
  }
}

Future<void> updateUserPassword({required String password}) async {
  final token = await getToken();
  if (token == null) return;

  final url = Uri.parse('$_base/me/password');

  final body = {'password': password};

  try {
    final response = await http.put(
      url,
      headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 204) {
      debugPrint(' --- update user password successfully');
      UserDataCache().initialize();
    }
  } catch (e) {
    debugPrint('Error updating user password: $e');
  }
}

Future<void> deleteAccount() async {
  final token = await getToken();
  if (token == null) return;

  final url = Uri.parse('$_base/me');

  try {
    final response = await http.delete(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 204) {
      debugPrint(' --- delete user successfully');
      UserDataCache().clear();
    }
  } catch (e) {
    debugPrint('Error deleting user: $e');
  }
}

class UserDataCache {
  static final UserDataCache _instance = UserDataCache._internal();
  factory UserDataCache() => _instance;
  UserDataCache._internal();

  Map<String, String?>? _cachedData;
  bool _isFetching = false;
  bool _isFetchingImage = false;

  bool get isLoaded => _cachedData == null;
  void clear() => _cachedData = null;

  Future<void> initialize() async {
    debugPrint('\n-------------------------');
    debugPrint('\n---- initializing data --');
    if (!isLoaded || !_isFetching) _isFetching = true;
    try {
      debugPrint(' -- Fetching');
      final response = await getProfile();
      debugPrint(' -- result status_code: ${response?.statusCode}');
      debugPrint(' -- result body: ${response?.body}');
      if (response != null && response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
        debugPrint(' -- result: ${prettier(data)}');
        _cachedData = data.map((key, value) => MapEntry(key, value?.toString()));

        debugPrint('--- USER DATA FETCHED ---');
        _cachedData!.forEach((key, value) {
          debugPrint('$key: $value');
        });

        await _loadRemoteImage();

        debugPrint('-------------------------');
      } else {
        debugPrint(
            ' -- FAILED TO INITIALIZE USERDATA: ${response?.statusCode} - ${response?.body}');
      }
    } catch (e) {
      debugPrint(' --- FAILED TO INITIALIZE USERDATA REQUEST: $e');
    } finally {
      _isFetching = false;
    }
  }

  void saveProfileImage(Uint8List image) {
    _cachedData?['image'] = base64Encode(image);
  }

  String get id => _cachedData?['id'] ?? '4df16de9-121e-4d3d-af75-7acfd5fd9fef';
  String get name => _cachedData?['fullname'] ?? 'Usuário Silva Sobrenome';
  String get email => _cachedData?['email'] ?? 'usuario@email.com';
  String get crefito => _cachedData?['crefito'] ?? '123456-F';

  ImageProvider get imageProfile {
    final String? base64String = _cachedData?['image'];

    if (base64String == null || base64String.isEmpty) {
      return const AssetImage('assets/fake_profile.jpg');
    }

    final Uint8List bytes = base64Decode(base64String);
    return MemoryImage(bytes);
  }

  String get userName {
    final parts = name.split(' ');
    return '${parts.first} ${parts.last}';
  }

  String get firstName {
    final parts = name.split(' ');
    return parts.first;
  }

  Future<void> _loadRemoteImage() async {
    if (_cachedData?['image'] != null || _isFetchingImage) return;

    _isFetchingImage = true;

    try {
      final base64Image = await fetchProfileImage();

      if (base64Image != null && base64Image.isNotEmpty) {
        _cachedData?['image'] = base64Image;
      }
    } catch (e) {
      debugPrint('Error loading background image: $e');
    } finally {
      _isFetchingImage = false;
    }
  }
}

String obscureText(String text) {
  if (!text.contains('@')) {
    return text.substring(0).replaceRange(0, text.length, '*****');
  }

  final partsEmail = text.split('@');
  final firstPart = partsEmail[0];
  final domainAnoni = firstPart.substring(0).replaceRange(0, firstPart.length, '*****');
  return '$domainAnoni@${partsEmail[1]}';
}
