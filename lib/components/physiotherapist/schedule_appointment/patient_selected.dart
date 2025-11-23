import 'package:flutter/material.dart';
import 'package:physioapp/model/user/patient/patient_user.dart';

class PatientSelected extends StatelessWidget {
  final PatientUser patientUser;
  const PatientSelected({
    super.key,
    required this.patientUser,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey,
        backgroundImage: FileImage(patientUser.imageProfile),
        maxRadius: 30,
      ),
      title: Text(patientUser.name),
      subtitle: Text(patientUser.email),
    );
  }
}
