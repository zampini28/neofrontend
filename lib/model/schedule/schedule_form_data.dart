import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:physioapp/services/schedule/schedule_appointment_form.dart';

class ScheduleFormData {
  static String? name;
  static String? occurrence;
  static DateTime? consultationDate;
  static TimeOfDay? consultationTime;
  static TypeQuery? typeQuery;

  String? get dateTimeConsultation {
    String date = '';
    String time = '';
    if (consultationDate != null) {
      return date = DateFormat.yMd().format(consultationDate!);
    }
    if (consultationTime != null) {
      return time = DateFormat.jm(consultationTime).toString();
    }

    return date.isEmpty || time.isEmpty ? '' : '$date $time';
  }
}
