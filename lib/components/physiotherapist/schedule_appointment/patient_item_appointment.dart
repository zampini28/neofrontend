import 'package:flutter/material.dart';
import 'package:physioapp/model/user/patient/patient_user.dart';
import 'package:physioapp/services/schedule/schedule_appointment_controller.dart';
import 'package:provider/provider.dart';

class PatientItemAppointment extends StatelessWidget {
  final PatientUser patientUser;
  const PatientItemAppointment({
    super.key,
    required this.patientUser,
  });

  @override
  Widget build(BuildContext context) {
    final scheduleProvider =
        Provider.of<ScheduleAppointmentController>(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey,
        backgroundImage: FileImage(patientUser.imageProfile),
        maxRadius: 30,
      ),
      title: Text(patientUser.name),
      subtitle: Text(patientUser.email),
      onTap: () {
        scheduleProvider.whenSelectPatient(patient: patientUser);

        Navigator.of(context).pop();
      },
    );
  }
}
