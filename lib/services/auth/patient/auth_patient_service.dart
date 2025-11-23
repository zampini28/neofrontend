import 'dart:io';

import 'package:physioapp/model/user/patient/patient_user.dart';
import 'package:physioapp/services/auth/patient/auth_patient_backend_service.dart';

abstract class AuthPatientService {
  PatientUser? get currentPatientUser;

  String? get tokenPatient;

  Future<void> signUp({
    required File imageProfile,
    required String name,
    required String email,
    required String password,
  });

  Future<void> login({required String email, required String password});

  Future<void> deleteAccount({required PatientUser currentUser});

  Future<void> updateUser({
    PatientUser? currentUser,
    String? password,
    String? name,
    String? email,
  });

  Future<void> logout();

  factory AuthPatientService() {
    return AuthPatientBackendService();
  }
}
