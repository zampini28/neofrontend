import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:physioapp/services/auth/auth.dart';
import 'package:physioapp/utils/domain_connection.dart';

class AppointmentService {
  AppointmentService._();
  static Future<bool> createAppointment({
    required String patientId,
    required String dateTimeIso,
    required int durationMinutes,
    required String notes,
  }) async {
    final token = await getToken();
    final physioId = UserDataCache().id;
    final url = Uri.parse('${DomainConnection().url}/appointments');

    final payload = {
      'physiotherapistId': physioId,
      'patientId': patientId,
      'dateTime': dateTimeIso,
      'durationMinutes': durationMinutes,
      'notes': notes
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
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
