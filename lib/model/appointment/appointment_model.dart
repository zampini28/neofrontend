import 'dart:convert';

import 'package:flutter/material.dart';


String prettier(Map<String, dynamic> jsonMap) =>
    const JsonEncoder.withIndent('  ').convert(jsonMap);


class AppointmentModel {
  final String id;
  final String patientName;
  final String patientImage;
  final DateTime dateTime;
  final int duration;
  final String status;
  final String notes;

  AppointmentModel({
    required this.id,
    required this.patientName,
    required this.patientImage,
    required this.dateTime,
    required this.duration,
    required this.status,
    required this.notes,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    // 1. Name Strategy: Check Flat 'patientName' first (Matches your API)
    String pName = json['patientName'] as String? ?? '';

    // Fallback: Check nested 'patient' object if flat name is missing
    if (pName.isEmpty) {
      final patientData = json['patient'];
      if (patientData is Map<String, dynamic>) {
        pName = patientData['fullname'] as String? ?? '';
      }
    }
    // Final fallback
    if (pName.isEmpty) pName = 'Paciente';

    // 2. Image Strategy: Check Flat keys, then nested
    // Note: Your provided JSON does NOT have an image field, so this will likely return empty
    // and your UI will show the default avatar. This is expected based on the API response.
    String pImage = json['patientImage'] ?? json['profileImage'] ?? '';

    if (pImage.isEmpty) {
      final patientData = json['patient'];
      if (patientData is Map<String, dynamic>) {
        pImage = patientData['profileImage'] ?? patientData['profile_image'] ?? '';
      }
    }

    // 3. Date Strategy
    DateTime pDate = DateTime.now();
    if (json['dateTime'] != null) {
      pDate = DateTime.parse(json['dateTime']);
    } else if (json['dateSchedule'] != null) {
      pDate = DateTime.parse(json['dateSchedule']);
    }

    return AppointmentModel(
      id: json['id']?.toString() ?? '',
      patientName: pName,
      patientImage: pImage,
      dateTime: pDate,
      duration: json['durationMinutes'] ?? json['duration'] ?? 60,
      status: json['status'] ?? 'SCHEDULED',
      // Notes might be missing from the JSON if they are null in DB
      notes: json['notes'] ?? json['description'] ?? '',
    );
  }
}
