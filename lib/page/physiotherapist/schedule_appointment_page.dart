import 'package:flutter/material.dart';
import 'package:physioapp/components/physiotherapist/schedule_appointment/first_form_schedule_appointment.dart';
import 'package:physioapp/components/physiotherapist/schedule_appointment/second_form_schedule_appointment.dart';
import 'package:physioapp/components/physiotherapist/schedule_appointment/select_form.dart';
import 'package:physioapp/model/schedule/schedule_form_data.dart';
import 'package:physioapp/services/appointment/appointment_service.dart';
import 'package:physioapp/services/schedule/schedule_appointment_form.dart';
import 'package:physioapp/utils/app_routes.dart';
import 'package:physioapp/utils/temp_globals.dart';
import 'package:provider/provider.dart';

class ScheduleAppointmentPage extends StatefulWidget {
  const ScheduleAppointmentPage({super.key});

  @override
  State<ScheduleAppointmentPage> createState() => _ScheduleAppointmentPageState();
}

class _ScheduleAppointmentPageState extends State<ScheduleAppointmentPage> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    clearGlobals();
  }

  Future<void> _handleCreateAppointment() async {
    if (globalSelectedPatientId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione um paciente primeiro.')),
      );
      return;
    }

    if (ScheduleFormData.isoDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione data e hora para a consulta.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final patientId = globalSelectedPatientId!;
    final dateTimeIso = ScheduleFormData.isoDateTime!;
    final durationMinutes = ScheduleFormData.durationMinutes;
    final notes = ScheduleFormData.occurrence ?? '';

    final success = await AppointmentService.createAppointment(
      patientId: patientId!,
      dateTimeIso: dateTimeIso,
      durationMinutes: durationMinutes,
      notes: notes,
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Consulta agendada com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );

      clearGlobals();
      ScheduleFormData.clear();

      Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.tabPagePhysio, (_) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao agendar. Verifique se o horário está disponível.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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
                  margin: const EdgeInsets.only(left: 20, right: 20, bottom: 120),
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10),
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
                      if (scheduleProvider.firstForm) const FirstFormScheduleAppointment(),
                      if (scheduleProvider.secondForm) const SecondFormScheduleAppointment(),
                      const SelectForm(),
                      const SizedBox(height: 10),
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
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
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
                            onPressed: _isLoading ? null : _handleCreateAppointment,
                            child: _isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Text(
                                    'Agendar Consulta',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontFamily:
                                          Theme.of(context).textTheme.titleSmall?.fontFamily,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                          ),
                        ),
                      if (scheduleProvider.secondForm)
                        Center(
                          child: TextButton(
                            onPressed: () {
                              scheduleProvider.toggleForm(
                                valueForm: scheduleProvider.getFirstForm,
                              );
                            },
                            child: const Text('Voltar'),
                          ),
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
