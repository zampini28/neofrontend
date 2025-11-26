import 'package:flutter/material.dart';
import 'package:physioapp/components/patient/profile/data_visualization_patient.dart';
import 'package:physioapp/components/patient/profile/other_options_patient.dart';
import 'package:physioapp/components/patient/profile/photo_profile_patient.dart';
import 'package:physioapp/components/patient/profile/profile_data_patient.dart';
import 'package:physioapp/components/physiotherapist/profile/photo_profile_physio.dart';
import 'package:physioapp/services/auth/auth.dart';
import 'package:physioapp/services/profile/patient/patient_profile_service.dart';
import 'package:provider/provider.dart';

class PatientProfilePage extends StatefulWidget {
  const PatientProfilePage({super.key});

  @override
  State<PatientProfilePage> createState() => _PatientProfilePageState();
}

class _PatientProfilePageState extends State<PatientProfilePage> {

  @override
  Widget build(BuildContext context) {
    final currentUser = UserDataCache();
    final profileProvider = Provider.of<PatientProfileService>(context);

    void refreshPage() {
      setState(() {});
    }

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24.0),
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 60),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromARGB(255, 223, 224, 234),
                        Color.fromARGB(255, 233, 235, 240),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: const Stack(
                          children: [
                            Center(
                              child: PhotoProfilePhysio(),
                            ),
                            Positioned(
                              right: 1,
                              child: DataVisualizationPatient(),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        profileProvider.isVisible
                            ? currentUser.userName
                            : obscureText(currentUser.userName),
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ProfileDataPatient(
                        refreshPage: refreshPage,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10.0),
                  margin: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 60,
                    bottom: 150,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromARGB(255, 223, 224, 234),
                        Color.fromARGB(255, 233, 235, 240),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Outros',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      OtherOptionsPatient(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
