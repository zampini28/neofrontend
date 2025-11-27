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
    final patient = json['patient'] ?? {};

    return AppointmentModel(
      id: json['id']?.toString() ?? '',
      patientName: patient['fullname'] as String? ?? 'Paciente Desconhecido',
      patientImage: patient['profileImage'] as String? ?? '',
      dateTime:
          json['dateTime'] != null ? DateTime.parse(json['dateTime'] as String) : DateTime.now(),
      duration: json['durationMinutes'] as int? ?? 60,
      status: json['status'] as String? ?? 'SCHEDULED',
      notes: json['notes'] as String? ?? '',
    );
  }
}
