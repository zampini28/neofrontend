import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:physioapp/repositories/relationship_repository.dart';
import 'package:physioapp/services/services.dart';
import 'package:physioapp/utils/domain_connection.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

// 1. The Model
class AppointmentModel {
  final String id;
  final DateTime dateTime;
  final String notes;
  final String patientName;
  final String patientImage; // Base64 string or URL
  final String status;
  final int durationInMinutes;

  AppointmentModel({
    required this.id,
    required this.dateTime,
    required this.notes,
    required this.patientName,
    required this.patientImage,
    required this.status,
    required this.durationInMinutes,
  });
}

// 2. The Service Function
Future<List<AppointmentModel>> fetchAllAppointments() async {
  // Configuration
  final String baseUrl = DomainConnection().url; // Replace with your actual URL

  try {
    // A. Get Token
    final String token = await getToken() as String;
    final Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    // B. Fetch Appointments (Page 0, Size 100 to get "all" relevant)
    // Adjust size as needed or implement loop for pagination
    final response = await http.get(
      Uri.parse('$baseUrl/appointments?page=0&size=100'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load appointments: ${response.statusCode}');
    }

    final Map<String, dynamic> body =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    final List<dynamic> content =
        body['content'] as List<dynamic>; // Spring Page<?> usually returns inside 'content'

    // C. Process List & Fetch Patient Details in Parallel
    // We map each appointment JSON to a Future<AppointmentModel>
    final futures = content.map((apptJson) async {
      final String patientId = apptJson['patientId'] as String;

      String patientImage = "";

      
      try {
        final patientResponse = await http.get(
          Uri.parse('$baseUrl/users/$patientId/image'), // Or /users/$id if image is in profile
          headers: headers,
        );
        if (patientResponse.statusCode == 200) {
          final patientData = jsonDecode(patientResponse.body);
          patientImage = patientData['image_profile'] as String? ?? "";
        }
      } catch (e) {
        debugPrint("Could not fetch image for patient $patientId");
      }

      debugPrint('json: ${prettier(apptJson as Map<String, dynamic>)}');

      return AppointmentModel(
        id: apptJson['id'] as String,
        dateTime: DateTime.parse(apptJson['dateTime'] as String),
        notes: apptJson['notes'] as String? ?? '',
        patientName: apptJson['patientName'] as String? ?? 'Unknown',
        patientImage: patientImage, // From the extra fetch or default
        status: apptJson['status'] as String,
        durationInMinutes: apptJson['durationMinutes'] as int? ?? 60,
      );
    });

    // Wait for all inner requests to complete
    return await Future.wait(futures);
  } catch (e) {
    debugPrint('Error fetching appointments: $e');
    return []; // Return empty list on error
  }
}

class DailyAppointmentsList extends StatelessWidget {
  const DailyAppointmentsList();

  @override
  Widget build(BuildContext context) {
    // 1. Use FutureBuilder to handle async data
    return FutureBuilder<List<AppointmentModel>>(
      future: fetchAllAppointments(),
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
            if (appt.patientImage is String && (appt.patientImage as String).isNotEmpty) {
              try {
                bgImage = MemoryImage(base64Decode(appt.patientImage as String));
              } catch (_) {
                bgImage = const AssetImage('assets/fake_profile.jpg');
              }
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
                        DateFormat('HH:mm').format(appt.dateTime),
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
                    backgroundImage: appt.patientImage.isNotEmpty
                        ? MemoryImage(base64Decode(appt.patientImage))
                        : const AssetImage('assets/fake_profile.jpg'),
                  ),
                  const SizedBox(width: 16),
                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appt.patientName,
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
                                appt.notes,
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
