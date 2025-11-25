import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:physioapp/services/schedule/schedule_appointment_form.dart';

class ScheduleFormData {
  static String? patientId; // NEW: Store the ID
  static String? name;
  static String? occurrence;
  static DateTime? consultationDate;
  static TimeOfDay? consultationTime;
  static TypeQuery? typeQuery;

  // Helper to combine Date and Time into ISO 8 601 string for API
  static String? get isoDateTime {
    if (consultationDate == null || consultationTime == null) return null;

    final dt = DateTime(
      consultationDate!.year,
      consultationDate!.month,
      consultationDate!.day,
      consultationTime!.hour,
      consultationTime!.minute,
    );

    return dt.toIso8601String();
  }

  String? get dateTimeConsultation {
    String date = '';
    String time = '';
    if (consultationDate != null) {
      date = DateFormat.yMd().format(consultationDate!);
    }
    if (consultationTime != null) {
      time = DateFormat.jm()
          .format(DateTime(2022, 1, 1, consultationTime!.hour, consultationTime!.minute));
    }

    return (date.isEmpty && time.isEmpty) ? '' : '$date $time';
  }

  static void clear() {
    patientId = null;
    name = null;
    occurrence = null;
    consultationDate = null;
    consultationTime = null;
    typeQuery = null;
  }
}
