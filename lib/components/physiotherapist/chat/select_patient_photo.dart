import 'dart:io';

import 'package:flutter/material.dart';

class SelectPatientPhoto extends StatelessWidget {
  final File imagePatient;
  final int patientCount;
  const SelectPatientPhoto({
    super.key,
    required this.imagePatient,
    required this.patientCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 70,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Scrollable(
        viewportBuilder: (context, position) => ListView.builder(
          shrinkWrap: true,
          itemCount: patientCount,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () {
              // Mesmo metodo utilizado no list_patient, para redirecionar ao chat do paciente
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                maxRadius: 30,
                backgroundImage: FileImage(imagePatient),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
