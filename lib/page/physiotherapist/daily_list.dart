import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:physioapp/page/physiotherapist/appointment_details_page.dart';
import 'package:physioapp/repositories/relationship_repository.dart';
import 'package:physioapp/services/services.dart';
import 'package:physioapp/utils/domain_connection.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

/// Fetches the profile image of a specific Physiotherapist (or any connected user).
///
/// [physioId] - The UUID of the physiotherapist.
/// [token] - The JWT auth token.
Future<String> fetchPhysiotherapistImage({
  required String physioId,
  required String token,
}) async {
  final String baseUrl = DomainConnection().url;

  if (physioId.isEmpty) return '';

  try {
    final response = await http.get(
      Uri.parse('$baseUrl/users/$physioId/image'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          jsonDecode(utf8.decode(response.bodyBytes));

      final String? image = data['profile_image'];

      return image ?? '';
    } else if (response.statusCode == 404) {
      debugPrint('Physio has no image set (404).');
      return '';
    } else if (response.statusCode == 403) {
      debugPrint(
          'Access Denied (403) fetching image for $physioId. checking self...');

      return '';
    } else {
      debugPrint('Failed to fetch physio image: ${response.statusCode}');
      debugPrint('Failed to fetch physio image: ${response.body}');
      return '';
    }
  } catch (e) {
    debugPrint('Network error fetching physio image: $e');
    return '';
  }
}

class AppointmentModel {
  final String id;
  final DateTime dateTime;
  final String notes;
  final String patientName;
  final String patientImage;
  final String physiotherapistName;
  final String physiotherapistImage;
  final String status;
  final int durationInMinutes;

  AppointmentModel({
    required this.id,
    required this.dateTime,
    required this.notes,
    required this.patientName,
    required this.patientImage,
    required this.physiotherapistName,
    required this.physiotherapistImage,
    required this.status,
    required this.durationInMinutes,
  });
}

Future<List<AppointmentModel>> fetchAllAppointments() async {
  final String baseUrl = DomainConnection().url;

  try {
    final String token = (await getToken())!;
    final Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response = await http.get(
      Uri.parse('$baseUrl/appointments?page=0&size=100'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load appointments: ${response.statusCode}');
    }

    final Map<String, dynamic> body =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    final List<dynamic> content = body['content'] as List<dynamic>;

    final futures = content.map((apptJson) async {
      final String patientId = apptJson['patientId'] as String;

      final patient = await http.get(
        Uri.parse('$baseUrl/api/relationships/$patientId'),
        headers: headers,
      );

      final Map<String, dynamic> patientBody =
          jsonDecode(utf8.decode(patient.bodyBytes)) as Map<String, dynamic>;
      final String patientImage = patientBody['profileImage'] as String? ?? '';

      debugPrint('json: ${prettier(apptJson as Map<String, dynamic>)}');

      String physioImg = await fetchPhysiotherapistImage(
          physioId: apptJson['physiotherapistId'], token: token);

      return AppointmentModel(
        id: apptJson['id'] as String,
        dateTime: DateTime.parse(apptJson['dateTime'] as String),
        notes: apptJson['notes'] as String? ?? '',
        patientName: apptJson['patientName'] as String? ?? 'Unknown',
        physiotherapistName:
            apptJson['physiotherapistName'] as String? ?? 'Unknown',
        patientImage: patientImage,
        physiotherapistImage: physioImg,
        status: apptJson['status'] as String,
        durationInMinutes: apptJson['durationMinutes'] as int? ?? 60,
      );
    });

    return await Future.wait(futures);
  } catch (e) {
    debugPrint('Error fetching appointments: $e');
    return [];
  }
}

class DailyAppointmentsList extends StatelessWidget {
  const DailyAppointmentsList({super.key});

  @override
  Widget build(BuildContext context) {
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
                  Icon(Icons.event_busy_rounded,
                      size: 48, color: Colors.grey[300]),
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

            ImageProvider bgImage;
            if (appt.patientImage.isNotEmpty) {
              try {
                bgImage = MemoryImage(base64Decode(appt.patientImage));
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
                    backgroundImage: UserDataCache().isPatient
                        ? appt.physiotherapistImage.isNotEmpty
                            ? MemoryImage(
                                base64Decode(appt.physiotherapistImage))
                            : const AssetImage('assets/fake_profile.jpg')
                        : appt.patientImage.isNotEmpty
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
                          UserDataCache().isPatient
                              ? appt.physiotherapistName
                              : appt.patientName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Color(0xFF2D3142),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
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
                        debugPrint('Appointment tapped: ${appt.id}');
                        debugPrint('Appointment json: ${appt.notes}');

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AppointmentDetailsPage(
                              appointment: appt,
                            ),
                          ),
                        );
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
