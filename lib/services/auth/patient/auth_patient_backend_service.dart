import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:physioapp/model/user/patient/patient_user.dart';
import 'package:physioapp/services/auth/auth_form.dart';
import 'package:physioapp/services/auth/patient/auth_patient_service.dart';
import 'package:physioapp/services/auth/patient/patient_endpoint.dart';

class AuthPatientBackendService implements AuthPatientService {
  final endpoints = PatientEndpoint();

  static String? _globalToken;
  File? image;

  void _updatePatientUser({required dynamic user, File? imageProfile}) {
    _currentUserPatient = PatientUser(
      id: user['id'].toString(),
      imageProfile: imageProfile ?? File(''),
      name: user['fullname'] as String,
      email: user['email'] as String,
    );
  }

  static PatientUser? _currentUserPatient;

  @override
  String? get tokenPatient => _globalToken;

  @override
  // TODO: implement currentPhysioUser
  PatientUser? get currentPatientUser => _currentUserPatient;

  @override
  Future<void> signUp({
    required File imageProfile,
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await endpoints.registerEndpoint(
      name: name,
      password: password,
      email: email,
    );

    try {
      debugPrint('ocorreu tudo bem');
      final login = await endpoints.loginEndpoint(
        email: email,
        password: password,
      );

      try {
        final json = jsonDecode(login.body);
        final String? token = json['token'] as String?;

        if (token != null && token.isNotEmpty) {
          _globalToken = token;

          final current = await endpoints.meEndpoint(token: _globalToken!);

          final user = jsonDecode(current.body);

          image = imageProfile;

          _updatePatientUser(user: user, imageProfile: image);
        }
      } catch (error) {
        debugPrint(error.toString());
      }
    } catch (error) {
      debugPrint('ocorreu erro, deu ruim');
      debugPrint(response.statusCode.toString());
    }
  }

  @override
  Future<void> login({required String email, required String password}) async {
    final login = await endpoints.loginEndpoint(
      email: email,
      password: password,
    );

    try {
      final json = jsonDecode(login.body);
      final String? token = json['token'] as String?;

      if (token != null && token.isNotEmpty) {
        _globalToken = token;

        final current = await endpoints.meEndpoint(token: token);

        final user = jsonDecode(current.body);
        image = image;

        _updatePatientUser(user: user, imageProfile: image);
      } else {
        return;
      }
    } catch (error) {
      throw Exception(
        'Erro de acesso, verifique se o endereço de e-mail está correto',
      );
    }
  }

  @override
  Future<void> deleteAccount({required PatientUser currentUser}) async {
    final response = await endpoints.deleteEndpoint(
      userId: currentUser.id,
      token: _globalToken!,
    );

    try {
      debugPrint('Deu tudo certo');
    } catch (error) {
      debugPrint(response.toString());
    }
  }

  @override
  Future<void> updateUser({
    PatientUser? currentUser,
    String? password,
    String? name,
    String? email,
  }) async {
    debugPrint(_globalToken);
    final response = await endpoints.updateEndpoint(
      user: currentUser,
      token: _globalToken,
      password: password,
      email: email,
      name: name,
    );

    try {
      debugPrint('deu bom');

      final current = await endpoints.meEndpoint(token: _globalToken!);

      final user = jsonDecode(current.body);

      _updatePatientUser(user: user);
    } catch (error) {
      debugPrint(response.statusCode.toString());
      debugPrint('deu ruim');
    }
  }

  @override
  Future<void> logout() async {
    _currentUserPatient = null;
    _globalToken = null;
    AuthFormData.imageProfile = null;
  }
}
