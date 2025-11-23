import 'dart:io';

import 'package:flutter/material.dart';
import 'package:physioapp/model/user/patient/patient_user.dart';

class PairWithPatient with ChangeNotifier {
  static final List<PatientUser> _listPatientPair = [
    PatientUser(
      id: '1',
      name: 'Davi Ferreira da Silva de Oliveira',
      email: 'daviferreira@gmail.com',
      imageProfile: File(''),
    ),
    PatientUser(
      id: '2',
      name: 'Davi Oliveira',
      email: 'davi@gmail.com',
      imageProfile: File(''),
    ),
    PatientUser(
      id: '3',
      name: 'Caio',
      email: 'caio@gmail.com',
      imageProfile: File(''),
    ),
  ];

  List<PatientUser> get listPatientPair => [..._listPatientPair];

  void addPairPatient({required PatientUser userPatient}) {
    _listPatientPair.add(userPatient);
    notifyListeners();
  }

  void removePairPatient({required PatientUser user}) {
    _listPatientPair.removeWhere(
      (element) => element.id == user.id,
    );
    notifyListeners();
  }
}
