import 'package:flutter/material.dart';
import 'package:physioapp/components/patient/home/consultation_calendar_patient.dart';
import 'package:physioapp/components/patient/home/physio_appointment_list.dart';
import 'package:physioapp/components/patient/home/search_physio.dart';
import 'package:physioapp/services/auth/auth.dart';

class HomePatientPage extends StatelessWidget {
  const HomePatientPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = UserDataCache();

    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          onTap: () => Scaffold.of(context).openDrawer(),
                          child: CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: currentUser.imageProfile,
                            minRadius: 30,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Olá ${currentUser.firstName},',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            'Como você está hoje?',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Theme.of(context).textTheme.labelSmall?.color,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.notifications_outlined,
                        color: Theme.of(context).primaryColor,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SearchPhysio(),
            const ConsultationCalendarPatient(),
            const Expanded(
              child: PhysioAppointmentList(),
            ),
          ],
        ),
      ),
    );
  }
}
