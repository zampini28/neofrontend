import 'package:flutter/material.dart';
import 'package:physioapp/components/physiotherapist/schedule_appointment/preview_map.dart';
import 'package:physioapp/model/schedule/schedule_form_data.dart';
import 'package:physioapp/services/schedule/schedule_appointment_form.dart';
import 'package:provider/provider.dart';

class SecondFormScheduleAppointment extends StatefulWidget {
  const SecondFormScheduleAppointment({super.key});

  @override
  State<SecondFormScheduleAppointment> createState() =>
      _SecondFormScheduleAppointmentState();
}

class _SecondFormScheduleAppointmentState
    extends State<SecondFormScheduleAppointment> {
  Future<void> _showDatePicket() async {
    showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2026),
    ).then(
      (date) {
        ScheduleFormData.consultationDate = date;
      },
    );
  }

  Future<void> _showTimePicker() async {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then(
      (time) {
        ScheduleFormData.consultationTime = time;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheduleDate = ScheduleFormData();
    final typeQueryProvider = Provider.of<ScheduleAppointmentForm>(context);
    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(
                left: 10,
                top: 10,
                bottom: 16,
              ),
              child: Text(
                'Marcar Consulta',
                style: TextStyle(
                  fontSize: 22,
                  color: Theme.of(context).textTheme.labelLarge?.color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                backgroundColor: WidgetStatePropertyAll(
                  Theme.of(context).colorScheme.tertiary,
                ),
              ),
              onPressed: () {
                _showDatePicket();
              },
              child: Text(
                'Data da Consulta',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontFamily:
                      Theme.of(context).textTheme.titleSmall?.fontFamily,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                backgroundColor: WidgetStatePropertyAll(
                  Theme.of(context).colorScheme.tertiary,
                ),
              ),
              onPressed: () {
                _showTimePicker();
              },
              child: Text(
                'Hora da Consulta',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontFamily:
                      Theme.of(context).textTheme.titleSmall?.fontFamily,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Data e Hora da Consulta: ${scheduleDate.dateTimeConsultation}',
              style: TextStyle(
                color: Theme.of(context).textTheme.labelLarge?.color,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            RadioListTile(
              value: typeQueryProvider.inPersonTypeQuery,
              groupValue: typeQueryProvider.currentTypeQuery,
              onChanged: (value) {
                typeQueryProvider.toggleTypeQuery(
                  valueTypeQuery: value!,
                );
              },
              title: Text(
                'Presencial',
                style: TextStyle(
                  color: typeQueryProvider.currentTypeQuery ==
                          typeQueryProvider.inPersonTypeQuery
                      ? Colors.black
                      : Theme.of(context).textTheme.labelLarge?.color,
                ),
              ),
            ),
            RadioListTile(
              value: typeQueryProvider.onlineTypeQuery,
              groupValue: typeQueryProvider.currentTypeQuery,
              onChanged: (value) {
                typeQueryProvider.toggleTypeQuery(
                  valueTypeQuery: value!,
                );
              },
              title: Text(
                'Online',
                style: TextStyle(
                  color: typeQueryProvider.currentTypeQuery ==
                          typeQueryProvider.onlineTypeQuery
                      ? Colors.black
                      : Theme.of(context).textTheme.labelLarge?.color,
                ),
              ),
            ),
            if (typeQueryProvider.inPersonCurrentType) const PreviewMap(),
          ],
        ),
      ),
    );
  }
}
