import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:physioapp/model/user/physio/physio_user.dart';
import 'package:physioapp/utils/domain_connection.dart';

String prettier(Map<String, dynamic> jsonMap) =>
  const JsonEncoder.withIndent('  ').convert(jsonMap);

class PhysioEndpoint {
  final _url = DomainConnection().url;

  Future<http.Response> registerEndpoint({
    required String name,
    required String email,
    required String password,
    required String crefito,
  }) async {

    final json = {
      'fullname': name,
      'email': email,
      'password': password,
      'user_type': 'PHYSIO',
      'crefito': crefito,
    };

    debugPrint(' -- post register with: ${prettier(json)}');

    return await http
      .post(
        Uri.parse('$_url/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(json),
      )
      .timeout(
        const Duration(seconds: 5),
    );
  }

  Future<http.Response> loginEndpoint(
      {required String email, required String password}) async {

    final json = {
      'email': email,
      'password': password,
    };

    debugPrint(' -- post login with: ${prettier(json)}');

    return await http
        .post(
          Uri.parse('$_url/auth/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(json),
        )
        .timeout(
          const Duration(seconds: 5),
        );
  }

  Future<http.Response> meEndpoint({required String token}) async {
    final auth = {'Authorization': 'Bearer $token'};
    debugPrint(' -- get me with: $auth');
    return await http.get(
      Uri.parse('$_url/me'),
      headers: auth,
    ).timeout(
      const Duration(seconds: 5),
    );
  }

  Future<http.Response> deleteEndpoint(
      {required String userId, required String token}) async {
    final auth = {'Authorization': 'Bearer $token'};
    debugPrint(' -- delete me with id: $userId');
    debugPrint(' -- delete me with: $auth');
    return await http.delete(
      Uri.parse('$_url/users/$userId'),
      headers: auth,
    ).timeout(
      const Duration(seconds: 5),
    );
  }

  Future<http.Response> updateEndpoint({
    required PhysioUser? currentUser,
    required String token,
    String? name,
    String? email,
    String? password,
  }) async {
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final json = {
      'fullname': name ?? currentUser?.name,
      'email': email ?? currentUser?.email,
      'password': password,
    };

    
    debugPrint('-----------------------');
    debugPrint(' -- request put with id: ${currentUser?.id}');
    debugPrint(' -- request put with header: $headers');
    debugPrint(' -- request put with json: ${prettier(json)}');
    debugPrint('-----------------------');

    return await http
        .put(
          Uri.parse('$_url/users/${currentUser?.id}'),
          headers: headers,
          body: jsonEncode(json),
        )
        .timeout(
          const Duration(seconds: 5),
        );
  }
}
