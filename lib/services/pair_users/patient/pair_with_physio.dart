import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:physioapp/model/user/physio/physio_user.dart';
import 'package:physioapp/services/auth/auth_form.dart';
import 'package:physioapp/services/auth/patient/auth_patient_service.dart';
import 'package:physioapp/services/pair_users/patient/pair_patient_endpoint.dart';
import 'package:physioapp/services/pair_users/physio/pair_with_patient.dart';

class PairWithPhysio with ChangeNotifier {
  String? _userId;

  final List<PhysioUser> _listPhysioPair = [];

  List<PhysioUser> get listPhysioPair => [..._listPhysioPair];

  Future<void> readQRcode() async {
    try {
      final String code = await FlutterBarcodeScanner.scanBarcode(
        '#FF0000',
        'Cancelar',
        false,
        ScanMode.QR,
      );

      _userId = code != '-1' ? code : 'Não validado!';

      _addPairPhysio(userId: _userId!);
    } catch (error) {
      debugPrint('Não foi possivel validar o código');
    }
  }

  Future<void> _addPairPhysio({required String userId}) async {
    final endpoint = PairPatientEndpoint();
    final authService = AuthPatientService();
    final pairWithPatient = PairWithPatient();

    try {
      final physioData = await endpoint.pairWithPhysio(
        physioId: userId,
        token: authService.tokenPatient!,
      );

      final userPhysio = jsonDecode(physioData.body);

      _newPhysio(userPhysio: userPhysio);

      pairWithPatient.addPairPatient(
        userPatient: authService.currentPatientUser!,
      );
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  void removePairPhysio({required PhysioUser user}) {
    _listPhysioPair.removeWhere(
      (element) => element.id == user.id,
    );
    notifyListeners();
  }

  void _newPhysio({required dynamic userPhysio}) {
    final newPhysio = PhysioUser(
      id: userPhysio['id'].toString(),
      crefito: userPhysio['crefito'].toString(),
      physioType: RadioButton.physioOption,
      imageProfile: File(''),
      name: userPhysio['fullname'] as String,
      email: userPhysio['email'] as String,
    );

    _listPhysioPair.add(newPhysio);

    notifyListeners();
  }
}
