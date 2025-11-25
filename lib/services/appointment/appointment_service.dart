import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:physioapp/services/auth/auth.dart';
import 'package:physioapp/utils/domain_connection.dart';

class AppointmentService {
  static Future<bool> createAppointment({
    required String patientId,
    required String dateTimeIso,
    required String notes,
    int durationMinutes = 60,
  }) async {
    final token = await getToken();
    final physioId = UserDataCache().id; // Current logged user
    final url = Uri.parse('${DomainConnection().url}/appointments');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "physiotherapistId": physioId,
          "patientId": patientId,
          "dateTime": dateTimeIso,
          "durationMinutes": durationMinutes,
          "notes": notes
        }),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        debugPrint('Failed to create appointment: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('Error creating appointment: $e');
      return false;
    }
  }
}
