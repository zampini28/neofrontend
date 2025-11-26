import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:physioapp/model/schedule/schedule_form_data.dart';
import 'package:physioapp/services/schedule/schedule_appointment_form.dart';
import 'package:provider/provider.dart';

class SecondFormScheduleAppointment extends StatefulWidget {
  const SecondFormScheduleAppointment({super.key});

  @override
  State<SecondFormScheduleAppointment> createState() => _SecondFormScheduleAppointmentState();
}

class _SecondFormScheduleAppointmentState extends State<SecondFormScheduleAppointment> {
  // UI Helpers
  Future<void> _showDatePicker() async {
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2026),
    );

    if (pickedDate != null) {
      setState(() {
        ScheduleFormData.consultationDate = pickedDate;
      });
    }
  }

  Future<void> _showTimePicker() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        ScheduleFormData.consultationTime = pickedTime;
      });
    }
  }

  Widget _buildSelector({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Theme.of(context).primaryColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).textTheme.labelMedium?.color,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationSlider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.timer_outlined, size: 20, color: Theme.of(context).primaryColor),
              const SizedBox(width: 8),
              Text(
                'Duração: ${ScheduleFormData.durationMinutes} min',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ],
          ),
          Slider(
            value: ScheduleFormData.durationMinutes.toDouble(),
            min: 15,
            max: 120,
            divisions: 7,
            label: '${ScheduleFormData.durationMinutes} min',
            activeColor: Theme.of(context).primaryColor,
            onChanged: (val) {
              setState(() {
                ScheduleFormData.durationMinutes = val.round();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchType(ScheduleAppointmentForm typeQueryProvider) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          RadioListTile<TypeQuery>(
            value: typeQueryProvider.inPersonTypeQuery,
            groupValue: typeQueryProvider.currentTypeQuery,
            activeColor: Theme.of(context).primaryColor,
            onChanged: (value) {
              typeQueryProvider.toggleTypeQuery(valueTypeQuery: value!);
            },
            title: const Text(
              'Presencial',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            secondary: Icon(
              Icons.storefront_rounded,
              color: typeQueryProvider.currentTypeQuery == typeQueryProvider.inPersonTypeQuery
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(height: 1, color: Colors.grey.shade200),
          ),
          RadioListTile<TypeQuery>(
            value: typeQueryProvider.onlineTypeQuery,
            groupValue: typeQueryProvider.currentTypeQuery,
            activeColor: Theme.of(context).primaryColor,
            onChanged: (value) {
              typeQueryProvider.toggleTypeQuery(valueTypeQuery: value!);
            },
            title: const Text(
              'Online',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            secondary: Icon(
              Icons.videocam_rounded,
              color: typeQueryProvider.currentTypeQuery == typeQueryProvider.onlineTypeQuery
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final typeQueryProvider = Provider.of<ScheduleAppointmentForm>(context);

    // Formaters
    final dateText = ScheduleFormData.consultationDate != null
        ? DateFormat('dd/MM/yyyy').format(ScheduleFormData.consultationDate!)
        : 'Selecionar Data';

    final timeText = ScheduleFormData.consultationTime != null
        ? ScheduleFormData.consultationTime!.format(context)
        : 'Selecionar Horário';

    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 10, top: 10, bottom: 16),
              child: Text(
                'Marcar Consulta',
                style: TextStyle(
                  fontSize: 22,
                  color: Theme.of(context).textTheme.labelLarge?.color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // Date
            _buildSelector(
              label: 'Data da Consulta',
              value: dateText,
              icon: Icons.calendar_month_rounded,
              onTap: _showDatePicker,
            ),

            // Time
            _buildSelector(
              label: 'Horário',
              value: timeText,
              icon: Icons.access_time_filled_rounded,
              onTap: _showTimePicker,
            ),

            // Duration
            _buildDurationSlider(),

            const SizedBox(height: 10),

            // if (typeQueryProvider.inPersonCurrentType)
            //   Padding(
            //     padding: const EdgeInsets.only(top: 16.0),
            //     child: const PreviewMap(),
            //   ),
          ],
        ),
      ),
    );
  }
}
