import 'package:flutter/material.dart';
import 'package:physioapp/components/physiotherapist/schedule_appointment/patient_selected.dart';
import 'package:physioapp/components/physiotherapist/schedule_appointment/show_patients_appoinments.dart';
import 'package:physioapp/model/schedule/schedule_form_data.dart';
import 'package:physioapp/model/user/patient/patient_user.dart';
import 'package:physioapp/models/chat/connected_user.dart';
import 'package:physioapp/repositories/relationship_repository.dart';
import 'package:physioapp/services/schedule/schedule_appointment_controller.dart';
import 'package:provider/provider.dart';

import 'package:physioapp/model/schedule/schedule_form_data.dart';

class FirstFormScheduleAppointment extends StatefulWidget {
  const FirstFormScheduleAppointment({super.key});

  @override
  State<FirstFormScheduleAppointment> createState() => _FirstFormScheduleAppointmentState();
}

class _FirstFormScheduleAppointmentState extends State<FirstFormScheduleAppointment> {
  final _formKey = GlobalKey<FormState>();
  ConnectedUser? _selectedUser;

  void _openPatientSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PatientSelectionSheet(
        onSelected: (user) {
          setState(() {
            _selectedUser = user;
          });

          ScheduleFormData.name = user.fullname;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheduleProvider = Provider.of<ScheduleAppointmentController>(context);
    final hasSelection = _selectedUser != null || scheduleProvider.whenSelected;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 10, top: 10, bottom: 16),
          child: Text(
            'Dados do Paciente',
            style: TextStyle(
              fontSize: 22,
              color: Theme.of(context).textTheme.labelLarge?.color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _openPatientSelector,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.transparent),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: hasSelection
                      ? Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                              backgroundImage: _selectedUser?.imageProvider,
                              child: _selectedUser?.profileImageBase64 == null
                                  ? (_selectedUser == null &&
                                          scheduleProvider.patientSelected != null)
                                      ? null
                                      : Icon(Icons.person, color: Theme.of(context).primaryColor)
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _selectedUser?.fullname ??
                                        scheduleProvider.patientSelected?.name ??
                                        'Paciente',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    _selectedUser?.email ??
                                        scheduleProvider.patientSelected?.email ??
                                        '',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.change_circle_outlined,
                                color: Theme.of(context).primaryColor),
                          ],
                        )
                      : Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.person_add_alt_1,
                                  color: Theme.of(context).primaryColor),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Selecionar Paciente',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black54,
                              ),
                            ),
                            const Spacer(),
                            const Icon(Icons.chevron_right, color: Colors.grey),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 20),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Motivo / Ocorrência',
                    labelStyle: Theme.of(context).textTheme.labelMedium,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(16),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 4,
                  keyboardType: TextInputType.multiline,
                  onChanged: (occurrence) => ScheduleFormData.occurrence = occurrence,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}



class PatientSelectionSheet extends StatefulWidget {
  final Function(ConnectedUser) onSelected;

  const PatientSelectionSheet({super.key, required this.onSelected});

  @override
  State<PatientSelectionSheet> createState() => _PatientSelectionSheetState();
}

class _PatientSelectionSheetState extends State<PatientSelectionSheet> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Ensure data is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RelationshipProvider>(context, listen: false).fetchConnections();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RelationshipProvider>(context);
    final patients = provider.connections.where((u) => u.type == UserType.PATIENT).toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          TextField(
            controller: _searchController,
            onChanged: provider.searchConnections,
            decoration: InputDecoration(
              hintText: 'Buscar paciente...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: provider.isLoadingConnections
                ? const Center(child: CircularProgressIndicator())
                : patients.isEmpty
                    ? Center(
                        child: Text(
                          'Nenhum paciente encontrado.',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      )
                    : ListView.separated(
                        itemCount: patients.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final user = patients[index];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                            leading: CircleAvatar(
                              radius: 24,
                              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                              backgroundImage: user.imageProvider,
                              child: user.profileImageBase64 == null
                                  ? Text(user.initials, style: TextStyle(color: Theme.of(context).primaryColor))
                                  : null,
                            ),
                            title: Text(
                              user.fullname,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(user.email),
                            onTap: () {
                              widget.onSelected(user);
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}