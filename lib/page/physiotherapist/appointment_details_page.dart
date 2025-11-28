import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:physioapp/page/physiotherapist/daily_list.dart';

class AppointmentDetailsPage extends StatelessWidget {
  final AppointmentModel appointment;

  const AppointmentDetailsPage({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    ImageProvider? imageProvider;
    if (appointment.patientImage.isNotEmpty) {
      try {
        imageProvider = MemoryImage(base64Decode(appointment.patientImage));
      } catch (e) {
        imageProvider = null;
      }
    }

    final dateStr = DateFormat("d 'de' MMMM 'de' yyyy", 'pt_BR').format(appointment.dateTime);
    final timeStr = DateFormat('HH:mm').format(appointment.dateTime);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Detalhes da Consulta'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF2D3142),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Header Profile
            Center(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Theme.of(context).primaryColor, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        )
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: imageProvider,
                      child: imageProvider == null
                          ? Icon(Icons.person, size: 50, color: Colors.grey[400])
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    appointment.patientName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3142),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getStatusColor(appointment.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _translateStatus(appointment.status),
                      style: TextStyle(
                        color: _getStatusColor(appointment.status),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Info Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // Time & Duration
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildInfoItem(Icons.calendar_today_rounded, dateStr, 'Data'),
                        Container(height: 40, width: 1, color: Colors.grey[200]),
                        _buildInfoItem(Icons.access_time_rounded, timeStr, 'Horário'),
                        Container(height: 40, width: 1, color: Colors.grey[200]),
                        _buildInfoItem(Icons.timer_outlined, '${appointment.durationInMinutes} min',
                            'Duração'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Notes / Description
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.notes_rounded, color: Theme.of(context).primaryColor),
                            const SizedBox(width: 10),
                            const Text(
                              'Observações / Queixa',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D3142),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          appointment.notes.isNotEmpty
                              ? appointment.notes
                              : 'Nenhuma observação registrada.',
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.5,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: Container(
      //   padding: const EdgeInsets.all(20),
      //   decoration: BoxDecoration(
      //     color: Colors.white,
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.black.withOpacity(0.05),
      //         blurRadius: 10,
      //         offset: const Offset(0, -5),
      //       ),
      //     ],
      //   ),
      //   child: ElevatedButton(
      //     onPressed: () {
      //       // Action to start consultation or edit
      //     },
      //     style: ElevatedButton.styleFrom(
      //       backgroundColor: Theme.of(context).primaryColor,
      //       padding: const EdgeInsets.symmetric(vertical: 16),
      //       shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.circular(16),
      //       ),
      //       elevation: 0,
      //     ),
      //     child: const Text(
      //       'Iniciar Atendimento',
      //       style: TextStyle(
      //         fontSize: 16,
      //         fontWeight: FontWeight.bold,
      //         color: Colors.white,
      //       ),
      //     ),
      //   ),
      // ),
    );
  }

  Widget _buildInfoItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey[400], size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Color(0xFF2D3142),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'SCHEDULED':
        return Colors.blue;
      case 'COMPLETED':
        return Colors.green;
      case 'CANCELLED':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  String _translateStatus(String status) {
    switch (status.toUpperCase()) {
      case 'SCHEDULED':
        return 'Agendado';
      case 'COMPLETED':
        return 'Concluído';
      case 'CANCELLED':
        return 'Cancelado';
      default:
        return status;
    }
  }
}
