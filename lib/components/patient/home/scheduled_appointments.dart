import 'package:flutter/material.dart';
import 'package:physioapp/components/patient/home/scheduled_appointments_item.dart';

class ScheduledAppointments extends StatelessWidget {
  const ScheduledAppointments({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Text(
            'Proxima consulta',
            style: TextStyle(
              color: Theme.of(context).textTheme.labelLarge?.color,
              fontSize: 16,
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: 2,
            itemBuilder: (context, index) {
              return const ScheduledAppointmentsItem();
            },
          ),
        ],
      ),
    );
  }
}
