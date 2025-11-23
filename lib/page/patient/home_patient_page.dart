import 'package:flutter/material.dart';

import 'package:physioapp/components/patient/home/scheduled_appointments.dart';
import 'package:physioapp/components/patient/home/view_shared_exercises_patient.dart';
import 'package:physioapp/services/auth/patient/auth_patient_service.dart';

class HomePatientPage extends StatelessWidget {
  const HomePatientPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final currentUser = AuthPatientService();
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 80,
                          child: Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 20),
                                child: GestureDetector(
                                  onTap: () =>
                                      scaffoldKey.currentState?.openDrawer(),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    backgroundImage: FileImage(
                                      currentUser
                                          .currentPatientUser!.imageProfile,
                                    ),
                                    minRadius: 30,
                                  ),
                                ),
                              ),
                              Container(
                                height: 50,
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Olá ${currentUser.currentPatientUser?.firstName},',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      'O que faremos hoje?',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.color,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 20),
                          child: CircleAvatar(
                            maxRadius: 25,
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.notifications_outlined,
                                size: 24,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const ViewSharedExercisesPatient(),
                  const ScheduledAppointments(),
                ],
              ),
            ),
          ],
        ),
      ),
      //drawer: const AppDrawerPatient(),
    );
  }
}
