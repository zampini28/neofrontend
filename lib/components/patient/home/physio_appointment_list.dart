import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Mock model for PhysioAppointment since we don't have a controller yet
class PhysioAppointment {
  final String physioName;
  final String specialty;
  final DateTime date;
  final String? imagePath;

  PhysioAppointment({
    required this.physioName,
    required this.specialty,
    required this.date,
    this.imagePath,
  });
}

class PhysioAppointmentList extends StatelessWidget {
  const PhysioAppointmentList({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data
    final List<PhysioAppointment> appointments = [
      PhysioAppointment(
        physioName: 'Dr. Ana Silva',
        specialty: 'Ortopedia',
        date: DateTime.now().add(const Duration(days: 1, hours: 2)),
      ),
      PhysioAppointment(
        physioName: 'Dr. Carlos Santos',
        specialty: 'Neurologia',
        date: DateTime.now().add(const Duration(days: 3, hours: 5)),
      ),
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: appointments.length,
      itemBuilder: (context, index) => appointments.isNotEmpty
          ? Container(
              width: double.infinity,
              height: 160,
              margin: const EdgeInsets.only(right: 20, left: 20, top: 20),
              padding: const EdgeInsets.only(right: 30, left: 30, top: 20, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 230,
                            child: Text(
                              appointments[index].physioName,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 230,
                            child: Text(
                              appointments[index].specialty,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 13,
                                color: Theme.of(context).textTheme.labelSmall?.color,
                              ),
                            ),
                          ),
                        ],
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.grey,
                        // Placeholder image logic
                        backgroundImage: appointments[index].imagePath != null
                            ? FileImage(File(appointments[index].imagePath!))
                            : null,
                        minRadius: 30,
                        child: appointments[index].imagePath == null
                            ? const Icon(Icons.person, color: Colors.white)
                            : null,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 160,
                        child: Text(
                          DateFormat.yMd().add_jms().format(
                                appointments[index].date,
                              ),
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 233, 235, 240),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Ver detalhes',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          : const Text('Nenhuma consulta agendada'),
    );
  }
}
