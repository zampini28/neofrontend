import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:physioapp/model/user/physio/physio_user.dart';
import 'package:physioapp/services/auth/auth.dart';
import 'package:physioapp/services/auth/auth_form.dart';
import 'package:physioapp/services/auth/physio/auth_physio_service.dart';
import 'package:physioapp/services/auth/physio/physio_endpoint.dart';

class AuthPhysioBackendService implements AuthPhysioService {
  final endpoints = PhysioEndpoint();

  static String? _globalToken;
  File? image;

  void _updatePhysioUser({required dynamic user, File? imageProfile, RadioButton? physioType}) {
    _currentUserPhysio = PhysioUser(
      id: user['id'] as String,
      crefito: user['crefito'] as String,
      physioType: physioType ?? RadioButton.physioOption,
      imageProfile: imageProfile ?? File(''),
      name: user['fullname'] as String,
      email: user['email'] as String,
    );
  }

  static PhysioUser? _currentUserPhysio;

  @override
  // TODO: implement currentPhysioUser
  PhysioUser? get currentPhysioUser => _currentUserPhysio;

  @override
  Future<void> signUp({
    required RadioButton physioType,
    required File imageProfile,
    required String name,
    required String email,
    required String password,
    required String crefito,
  }) async {

    // fazer registo
    final register = await authRegister(
      imageProfile: 'TODO: change this',
      fullname: name,
      email: email,
      password: password,
      userType: 'PHYSIO',
      crefito: crefito,
    );

    if (!register) {
      throw Exception('Usuário já existente!');
    }

    // fazer login
    final login = await authLogin(
      email: email,
      password: password,
    );

    if (!login) {
      throw Exception('Email ou senha incorretos.');
    }
  }

  @override
  Future<void> login({required String email, required String password}) async {
    debugPrint(' -- hello from login (AuthPhysioBackendService)');
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
        debugPrint('User ===> $user');
        image = image;

        _updatePhysioUser(user: user, imageProfile: image);
      }

      debugPrint(' -- goodbye from login (AuthPhysioBackendService)');
    } catch (error) {
      debugPrint('ocorreu erro, deu ruim');
      debugPrint(login.statusCode.toString());

      debugPrint(' -- goodbye with error from login (AuthPhysioBackendService)');
      throw Exception(
        'Erro de acesso, verifique se o endereço de e-mail está correto',
      );
    }
  }

  @override
  Future<void> deleteAccount({required PhysioUser currentUser}) async {
    final response = await endpoints.deleteEndpoint(userId: currentUser.id, token: _globalToken!);

    try {
      debugPrint('Deu tudo certo');
    } catch (error) {
      debugPrint(response.toString());
    }
  }

  @override
  Future<void> updateUser(
      {PhysioUser? currentUser, String? password, String? name, String? email}) async {
    final response = await endpoints.updateEndpoint(
      currentUser: currentUser,
      name: name,
      email: email,
      token: _globalToken!,
      password: password,
    );

    try {
      debugPrint('deu bom');

      final current = await endpoints.meEndpoint(token: _globalToken!);

      final user = jsonDecode(current.body);

      _updatePhysioUser(
        user: user,
        physioType: RadioButton.physioOption,
      );
    } catch (error) {
      debugPrint(response.statusCode.toString());
      debugPrint('deu ruim');
    }
  }

  @override
  Future<void> logout() async {
    _currentUserPhysio = null;
    _globalToken = null;
    AuthFormData.crefito = null;
    AuthFormData.imageProfile = null;
  }
}
