import 'package:physioapp/model/user/patient/patient_user.dart';

class Schedule {
  final String id;
  final PatientUser patient;
  final DateTime dateSchedule;
  final String symptoms;
  final int age;
  final double weight;
  final double height;

  const Schedule({
    required this.id,
    required this.patient,
    required this.dateSchedule,
    required this.symptoms,
    required this.age,
    required this.weight,
    required this.height,
  });
}
