import 'package:flutter/widgets.dart';
import 'package:physioapp/model/schedule/schedule.dart';
import 'package:physioapp/model/user/patient/patient_user.dart';

class ScheduleAppointmentController with ChangeNotifier{
  bool _whenSelected = false;
  PatientUser? _patientSelected;

  bool get whenSelected => _whenSelected;

  PatientUser? get patientSelected => _patientSelected;

  final List<Schedule> _listSchedule = [];

  List<Schedule> get listSchedule => [..._listSchedule];

  void whenSelectPatient({required PatientUser patient}) {
    _patientSelected = patient;
    _whenSelected = true;
    notifyListeners();
  }

  void addSchedule({required Schedule schedule}) {
    _listSchedule.add(schedule);
    notifyListeners();
  }
}