import 'package:flutter/material.dart';
import 'package:physioapp/components/physiotherapist/schedule_appointment/patient_item_appointment.dart';
import 'package:physioapp/services/pair_users/physio/pair_with_patient.dart';
import 'package:provider/provider.dart';

class ShowPatientsAppoinments extends StatefulWidget {
  const ShowPatientsAppoinments({super.key});

  @override
  State<ShowPatientsAppoinments> createState() =>
      _ShowPatientsAppoinmentsState();
}

class _ShowPatientsAppoinmentsState extends State<ShowPatientsAppoinments> {
  @override
  Widget build(BuildContext context) {
    final pairedPatietProvider = Provider.of<PairWithPatient>(context);
    print(pairedPatietProvider.listPatientPair.length);
    return SizedBox(
      height: pairedPatietProvider.listPatientPair.length * 80,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: pairedPatietProvider.listPatientPair.length,
        itemBuilder: (context, index) {
          return PatientItemAppointment(
            patientUser: pairedPatietProvider.listPatientPair.elementAt(index),
          );
        },
      ),
    );
  }
}
