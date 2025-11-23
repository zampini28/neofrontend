import 'package:flutter/material.dart';
import 'package:physioapp/components/patient/policy_privacy/data_retention_patient.dart';
import 'package:physioapp/services/navigation/bottom_nav_bar_patient_controller.dart';
import 'package:physioapp/utils/app_routes.dart';
import 'package:provider/provider.dart';

class PolicyPrivacyPatientPage extends StatelessWidget {
  const PolicyPrivacyPatientPage({super.key});

  @override
  Widget build(BuildContext context) {
    final navigatorProvider =
        Provider.of<BottomNavBarPatientController>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context)
                .pushNamedAndRemoveUntil(AppRoutes.tabPagePatient, (_) => false);
            navigatorProvider.toggleIndex(index: 2);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: const Text('Politica de Privacidade'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10.0),
              margin: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 60,
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
                children: [
                  DataRetentionPatient(),
                ],
              )),
        ),
      ),
    );
  }
}
