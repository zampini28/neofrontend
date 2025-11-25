import 'package:flutter/material.dart';
import 'package:physioapp/components/physiotherapist/schedule_appointment/first_form_schedule_appointment.dart';
import 'package:physioapp/components/physiotherapist/schedule_appointment/second_form_schedule_appointment.dart';
import 'package:physioapp/components/physiotherapist/schedule_appointment/select_form.dart';
import 'package:physioapp/services/auth/auth.dart';
import 'package:physioapp/services/schedule/schedule_appointment_form.dart';
import 'package:provider/provider.dart';

class ScheduleAppointmentPage extends StatefulWidget {
  const ScheduleAppointmentPage({super.key});

  @override
  State<ScheduleAppointmentPage> createState() =>
      _ScheduleAppointmentPageState();
}

class _ScheduleAppointmentPageState extends State<ScheduleAppointmentPage> {
  @override
  Widget build(BuildContext context) {
    final scheduleProvider = Provider.of<ScheduleAppointmentForm>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Agendamento de Consulta'),
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  margin:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 120),
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                    bottom: 10,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromARGB(255, 223, 224, 234),
                        Color.fromARGB(255, 233, 235, 240),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Column(
                    crossAxisAlignment: scheduleProvider.firstForm
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      if (scheduleProvider.firstForm)
                        const FirstFormScheduleAppointment(),
                      if (scheduleProvider.secondForm)
                        const SecondFormScheduleAppointment(),
                      const SelectForm(),
                      if (scheduleProvider.firstForm)
                        TextButton(
                          onPressed: () {

                            scheduleProvider.toggleForm(
                              valueForm: scheduleProvider.getSecondForm,
                            );
                          },
                          child: const Text(
                            'Proximo',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      if (scheduleProvider.secondForm)
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
                            minimumSize: const WidgetStatePropertyAll(
                              Size(double.infinity, 50),
                            ),
                          ),
                          onPressed: () {
                            makeAppointment();
                          },
                          child: Text(
                            'Agendar Consulta',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontFamily: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.fontFamily,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      if (scheduleProvider.secondForm)
                        TextButton(
                          onPressed: () {
                            scheduleProvider.toggleForm(
                              valueForm: scheduleProvider.getFirstForm,
                            );
                          },
                          child: const Text('Voltar'),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
