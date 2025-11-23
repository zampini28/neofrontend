import 'package:flutter/material.dart';
import 'package:physioapp/components/physiotherapist/schedule_appointment/patient_selected.dart';
import 'package:physioapp/components/physiotherapist/schedule_appointment/show_patients_appoinments.dart';
import 'package:physioapp/model/schedule/schedule_form_data.dart';
import 'package:physioapp/services/schedule/schedule_appointment_controller.dart';
import 'package:provider/provider.dart';

class FirstFormScheduleAppointment extends StatefulWidget {
  const FirstFormScheduleAppointment({super.key});

  @override
  State<FirstFormScheduleAppointment> createState() =>
      _FirstFormScheduleAppointmentState();
}

class _FirstFormScheduleAppointmentState
    extends State<FirstFormScheduleAppointment> {
  final _formKey = GlobalKey<FormState>();

  Future<void> _showPatientsAppoiments() async {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: const ShowPatientsAppoinments(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheduleProvider =
        Provider.of<ScheduleAppointmentController>(context);

    Widget defaultTextForm({required Widget textForm}) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: textForm,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(
            left: 10,
            top: 10,
            bottom: 16,
          ),
          child: Text(
            'Dados do Paciente',
            style: TextStyle(
              fontSize: 22,
              color: Theme.of(context).textTheme.labelLarge?.color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Form(
          key: _formKey,
          child: Column(
            spacing: 20,
            children: [
              if (scheduleProvider.whenSelected) PatientSelected(
                      patientUser: scheduleProvider.patientSelected!) else Container(
                      margin: const EdgeInsets.all(8.0),
                      child: TextButton.icon(
                        onPressed: () => _showPatientsAppoiments(),
                        label: const Text('Selecionar Paciente'),
                        icon: const Icon(Icons.person_add_alt_1_rounded),
                      ),
                    ),
              defaultTextForm(
                textForm: TextFormField(
                  decoration: InputDecoration(
                    label: Text(
                      'Ocorrência',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  onChanged: (occurrence) =>
                      ScheduleFormData.occurrence = occurrence,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
