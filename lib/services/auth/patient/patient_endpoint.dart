import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:physioapp/model/user/patient/patient_user.dart';
import 'package:physioapp/utils/domain_connection.dart';

class PatientEndpoint {
  final _url = DomainConnection().url;

  Future<http.Response> registerEndpoint({
    required String name,
    required String password,
    required String email,
  }) async {
    return await http
        .post(
          Uri.parse('$_url/auth/register'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'user_type': 'PATIENT',
            'fullname': name.toLowerCase(),
            'email': email.toLowerCase(),
            'password': password,
          }),
        )
        .timeout(
          const Duration(seconds: 5),
        );
  }

  Future<http.Response> loginEndpoint(
      {required String email, required String password}) async {
    return await http
        .post(
          Uri.parse('$_url/auth/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': email,
            'password': password,
          }),
        )
        .timeout(
          const Duration(seconds: 5),
        );
  }

  Future<http.Response> meEndpoint({required String token}) async {
    return await http.get(
      Uri.parse('$_url/me'),
      headers: {'Authorization': 'Bearer $token'},
    ).timeout(
      const Duration(seconds: 5),
    );
  }

  Future<http.Response> deleteEndpoint(
      {required String userId, required String token}) async {
    return await http.delete(
      Uri.parse('$_url/users/$userId'),
      headers: {'Authorization': 'Bearer $token'},
    ).timeout(
      const Duration(seconds: 5),
    );
  }

  Future<http.Response> updateEndpoint({
    required PatientUser? user,
    String? name,
    String? email,
    String? password,
    required String? token,
  }) async {
    return await http
        .put(
          Uri.parse('$_url/users/${user?.id}'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'fullname': name?.toLowerCase() ?? user?.name.toLowerCase(),
            'email': email?.toLowerCase() ?? user?.email.toLowerCase(),
            'password': password,
          }),
        )
        .timeout(
          const Duration(seconds: 5),
        );
  }
}
