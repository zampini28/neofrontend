import 'package:flutter/widgets.dart';
import 'package:physioapp/model/schedule/schedule.dart';
import 'package:physioapp/model/user/patient/patient_user.dart';

class ScheduleAppointmentController with ChangeNotifier {
  bool _whenSelected = false;
  PatientUser? _patientSelected;
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  bool get whenSelected => _whenSelected;

  PatientUser? get patientSelected => _patientSelected;

  DateTime get selectedDate => _selectedDate;
  DateTime get focusedDay => _focusedDay;

  final List<Schedule> _listSchedule = [];

  List<Schedule> get listSchedule => [..._listSchedule];

  List<Schedule> get appointmentsForSelectedDate {
    return _listSchedule.where((schedule) {
      return isSameDay(schedule.dateSchedule, _selectedDate);
    }).toList();
  }

  void whenSelectPatient({required PatientUser patient}) {
    _patientSelected = patient;
    _whenSelected = true;
    notifyListeners();
  }

  void addSchedule({required Schedule schedule}) {
    _listSchedule.add(schedule);
    notifyListeners();
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDate, selectedDay)) {
      _selectedDate = selectedDay;
      _focusedDay = focusedDay;
      notifyListeners();
    }
  }

  void updateFocusedDay(DateTime focusedDay) {
    _focusedDay = focusedDay;
    notifyListeners();
  }

  bool isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) {
      return false;
    }

    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
