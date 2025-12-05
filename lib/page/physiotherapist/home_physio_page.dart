import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:physioapp/model/appointment/appointment_model.dart';
import 'package:physioapp/model/schedule/schedule.dart';
import 'package:physioapp/services/appointment/appointment_service.dart';
import 'package:physioapp/services/auth/auth.dart';
import 'package:physioapp/services/schedule/schedule_appointment_controller.dart';
import 'package:physioapp/utils/domain_connection.dart';
import 'package:provider/provider.dart';
import 'package:physioapp/page/physiotherapist/daily_list.dart';

class HomePhysioPage extends StatefulWidget {
  const HomePhysioPage({super.key});

  @override
  State<HomePhysioPage> createState() => _HomePhysioPageState();
}

class _HomePhysioPageState extends State<HomePhysioPage> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ScheduleAppointmentController>(context, listen: false)
          .onDaySelected(DateTime.now(), DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = UserDataCache();
    final scheduleController =
        Provider.of<ScheduleAppointmentController>(context);
    final appointments = scheduleController.listSchedule;

    Schedule? nextAppointment;
    final now = DateTime.now();
    final futureAppointments = appointments
        .where((appt) => appt.dateSchedule.isAfter(now))
        .toList()
      ..sort((a, b) => a.dateSchedule.compareTo(b.dateSchedule));

    if (futureAppointments.isNotEmpty) {
      nextAppointment = futureAppointments.first;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, currentUser),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),

                    // const Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 20.0),
                    //   child: Text(
                    //     'Próximo Atendimento',
                    //     style: TextStyle(
                    //       fontSize: 18,
                    //       fontWeight: FontWeight.bold,
                    //       color: Color(0xFF2D3142),
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(height: 12),
                    // _NextAppointmentCard(appointment: nextAppointment),

                    // const SizedBox(height: 24),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Agenda',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3142),
                            ),
                          ),
                          Text(
                            DateFormat('MMMM yyyy', 'pt_BR')
                                .format(_selectedDate)
                                .toUpperCase(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _CalendarStrip(
                      selectedDate: _selectedDate,
                      onDateSelected: (date) {
                        setState(() {
                          _selectedDate = date;
                        });
                        scheduleController.onDaySelected(date, date);
                      },
                    ),

                    const SizedBox(height: 24),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        _isSameDay(_selectedDate, DateTime.now())
                            ? 'Hoje'
                            : DateFormat('EEEE, d', 'pt_BR')
                                .format(_selectedDate),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF9C9EB9),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const DailyAppointmentsList(),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, UserDataCache user) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => Scaffold.of(context).openDrawer(),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
              child: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey[300],
                backgroundImage: user.imageProfile,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Olá, ${user.firstName}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3142),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  UserDataCache().isPatient
                      ? 'O que faremos hoje?'
                      : 'Vamos cuidar dos seus pacientes?',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class _NextAppointmentCard extends StatelessWidget {
  final Schedule? appointment;

  const _NextAppointmentCard({this.appointment});

  @override
  Widget build(BuildContext context) {
    if (appointment == null) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child:
                  const Icon(Icons.calendar_today_rounded, color: Colors.grey),
            ),
            const SizedBox(width: 16),
            const Text(
              'Nenhuma consulta próxima.',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    final appt = appointment!;
    final timeStr = DateFormat('HH:mm').format(appt.dateSchedule);
    const durationStr = '1h';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white.withOpacity(0.1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.white24,
                        backgroundImage: FileImage(appt.patient.imageProfile),
                        onBackgroundImageError: (_, __) =>
                            const Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text(
                            appt.patient.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              appt.symptoms.isNotEmpty
                                  ? appt.symptoms
                                  : 'Consulta de rotina',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        const Icon(Icons.access_time_filled,
                            color: Colors.white70, size: 16),
                        const SizedBox(height: 4),
                        Text(
                          timeStr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _InfoBadge(
                        icon: Icons.monitor_weight_outlined,
                        label: '${appt.weight}kg'),
                    _InfoBadge(icon: Icons.height, label: '${appt.height}m'),
                    _InfoBadge(
                        icon: Icons.cake_outlined, label: '${appt.age} anos'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 16),
        const SizedBox(width: 4),
        Text(
          label,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _Old_CalendarStrip extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const _Old_CalendarStrip({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final startDate = now.subtract(const Duration(days: 10));
    final dates = List.generate(21, (i) => startDate.add(Duration(days: i)));

    return SizedBox(
      height: 90,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        primary: false,
        itemCount: dates.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected = _isSameDay(date, selectedDate);
          final isToday = _isSameDay(date, now);

          return GestureDetector(
            onTap: () => onDateSelected(date),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 6),
              width: 60,
              decoration: BoxDecoration(
                color:
                    isSelected ? Theme.of(context).primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: isToday && !isSelected
                    ? Border.all(
                        color: Theme.of(context).primaryColor, width: 2)
                    : null,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ]
                    : [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        )
                      ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('EEE', 'pt_BR')
                        .format(date)
                        .toUpperCase()
                        .replaceAll('.', ''),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    date.day.toString(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color:
                          isSelected ? Colors.white : const Color(0xFF2D3142),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _CalendarStrip extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const _CalendarStrip({
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final startDate = now.subtract(const Duration(days: 3));
    final dates =
        List.generate(21, (index) => startDate.add(Duration(days: index)));

    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: dates.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected = _isSameDay(date, selectedDate);
          final isToday = _isSameDay(date, now);

          return GestureDetector(
            onTap: () => onDateSelected(date),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 6),
              width: 60,
              decoration: BoxDecoration(
                color:
                    isSelected ? Theme.of(context).primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: isToday && !isSelected
                    ? Border.all(
                        color: Theme.of(context).primaryColor, width: 2)
                    : null,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ]
                    : [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        )
                      ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('EEE', 'pt_BR')
                        .format(date)
                        .toUpperCase()
                        .replaceAll('.', ''),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    date.day.toString(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color:
                          isSelected ? Colors.white : const Color(0xFF2D3142),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class NewAppointmentModel {
  final String id;
  final DateTime dateSchedule;
  final String symptoms;
  final NewPatientModel patient;

  NewAppointmentModel({
    required this.id,
    required this.dateSchedule,
    required this.symptoms,
    required this.patient,
  });

  factory NewAppointmentModel.fromJson(Map<String, dynamic> json) {
    return NewAppointmentModel(
      id: json['id']?.toString() ?? '',
      dateSchedule: json['dateTime'] != null
          ? DateTime.parse(json['dateTime'] as String)
          : DateTime.now(),
      symptoms: json['notes'] as String? ?? 'Sem descrição',
      patient: NewPatientModel.fromJson(
          json['patient'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class NewPatientModel {
  final String name;
  final dynamic imageProfile;

  NewPatientModel({required this.name, required this.imageProfile});

  factory NewPatientModel.fromJson(Map<String, dynamic> json) {
    final base64String = json['profileImage'];

    return NewPatientModel(
      name: json['fullname'] as String? ?? 'Paciente',
      imageProfile: base64String,
    );
  }
}
