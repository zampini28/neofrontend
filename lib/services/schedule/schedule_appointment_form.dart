import 'package:flutter/material.dart';

enum FormSchedule {
  firstForm,
  secondForm,
}

enum TypeQuery {
  inPerson,
  online,
}

class ScheduleAppointmentForm with ChangeNotifier {
  FormSchedule _currentForm = FormSchedule.firstForm;
  TypeQuery _currentTypeQuery = TypeQuery.online;

  FormSchedule get currentForm => _currentForm;
  TypeQuery get currentTypeQuery => _currentTypeQuery;

  FormSchedule get getFirstForm => FormSchedule.firstForm;
  FormSchedule get getSecondForm => FormSchedule.secondForm;
  TypeQuery get inPersonTypeQuery => TypeQuery.inPerson;
  TypeQuery get onlineTypeQuery => TypeQuery.online;

  bool get firstForm => _currentForm == FormSchedule.firstForm;
  bool get secondForm => _currentForm == FormSchedule.secondForm;

  bool get inPersonCurrentType => _currentTypeQuery == inPersonTypeQuery;

  void toggleForm({required FormSchedule valueForm}) {
    _currentForm = valueForm;
    notifyListeners();
  }

  void toggleTypeQuery({required TypeQuery valueTypeQuery}) {
    _currentTypeQuery = valueTypeQuery;
    notifyListeners();
  }
}
