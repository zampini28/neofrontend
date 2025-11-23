import 'package:flutter/material.dart';
import 'package:physioapp/services/schedule/schedule_appointment_form.dart';
import 'package:provider/provider.dart';

class SelectForm extends StatefulWidget {
  const SelectForm({super.key});

  @override
  State<SelectForm> createState() => _SelectFormState();
}

class _SelectFormState extends State<SelectForm> {
  @override
  Widget build(BuildContext context) {
    final scheduleProvider = Provider.of<ScheduleAppointmentForm>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Radio(
          value: FormSchedule.firstForm,
          groupValue: scheduleProvider.currentForm,
          onChanged: (value) {},
        ),
        Radio(
          value: FormSchedule.secondForm,
          groupValue: scheduleProvider.currentForm,
          onChanged: (value) {},
        ),
      ],
    );
  }
}
