import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:physioapp/model/appointment/appointment_model.dart';
import 'package:physioapp/services/auth/auth.dart';
import 'package:physioapp/utils/domain_connection.dart';

class AppointmentService {
  AppointmentService._();

  static Future<List<AppointmentModel>> fetchAppointments() async {
    final token = await getToken();
    final url = Uri.parse('${DomainConnection().url}/appointments');

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final dynamic decoded = jsonDecode(utf8.decode(response.bodyBytes));
        List<dynamic> list = [];

        if (decoded is Map && decoded.containsKey('content')) {
          list = decoded['content'] as List<dynamic>; 
        } else if (decoded is List) {
          list = decoded;
        }

        return list.map((json) => AppointmentModel.fromJson(json as Map<String, dynamic>)).toList();
        
      } else {
        debugPrint('Failed to load appointments: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('Error fetching appointments: $e');
      return [];
    }
  }

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
