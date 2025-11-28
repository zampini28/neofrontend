import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:physioapp/model/appointment/appointment_model.dart';
import 'package:physioapp/page/physiotherapist/home_physio_page.dart';
import 'package:physioapp/services/appointment/appointment_service.dart';

class _DailyAppointmentsList extends StatelessWidget {
  const _DailyAppointmentsList();

  // Helper to fetch and map data
  Future<List<NewAppointmentModel>> _fetchData() async {
    // Calling your existing service (assuming it returns raw list or similar)
    // We reuse the logic from AppointmentService but map to NewAppointmentModel
    final appointments =
        await AppointmentService.fetchAppointments(); // Returns List<AppointmentModel>

    // Convert AppointmentModel -> NewAppointmentModel to match your snippet
    return appointments.map((_old) {
      final old = _old as AppointmentModel;
      return NewAppointmentModel(
        id: old.id,
        dateSchedule: old.dateTime,
        symptoms: old.notes,
        patient: NewPatientModel(
          name: old.patientName,
          imageProfile: old.patientImage,
        ),
      );
    }).toList(); // Returns List<AppointmentModel>
  }

  @override
  Widget build(BuildContext context) {
    // 1. Use FutureBuilder to handle async data
    return FutureBuilder<List<NewAppointmentModel>>(
      future: _fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: Padding(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(),
          ));
        }

        final appointments = snapshot.data ?? [];

        if (appointments.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: [
                  Icon(Icons.event_busy_rounded, size: 48, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    'Sem consultas para este dia',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: appointments.length,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemBuilder: (context, index) {
            final appt = appointments[index];

            // 2. Handle Image: API returns Base64, snippet used FileImage
            // We switch to MemoryImage for Base64 support.
            ImageProvider bgImage;
            if (appt.patient.imageProfile is String &&
                (appt.patient.imageProfile as String).isNotEmpty) {
              try {
                bgImage = MemoryImage(base64Decode(appt.patient.imageProfile as String));
              } catch (_) {
                bgImage = const AssetImage('assets/fake_profile.jpg');
              }
            } else if (appt.patient.imageProfile is File) {
              bgImage = FileImage(appt.patient.imageProfile as File);
            } else {
              bgImage = const AssetImage('assets/fake_profile.jpg');
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Time Column
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('HH:mm').format(appt.dateSchedule),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF2D3142),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 4,
                        height: 25,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.tertiary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(width: 16),
                  // Profile Image
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: bgImage, // Updated
                  ),
                  const SizedBox(width: 16),
                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appt.patient.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Color(0xFF2D3142),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.description_outlined, size: 14, color: Colors.grey[500]),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                appt.symptoms,
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 13,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Action Button
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: () {
                        // Navigate to details if needed
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
