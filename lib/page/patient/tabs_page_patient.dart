import 'package:flutter/material.dart';
import 'package:physioapp/components/patient/bottom_nav_bar_patient.dart';
import 'package:physioapp/page/patient/chat_patient_page.dart';
import 'package:physioapp/page/patient/exercises_page.dart';
import 'package:physioapp/page/patient/home_patient_page.dart';
import 'package:physioapp/page/patient/patient_profile_page.dart';
import 'package:physioapp/services/navigation/bottom_nav_bar_patient_controller.dart';
import 'package:provider/provider.dart';

class TabsPagePatient extends StatefulWidget {
  const TabsPagePatient({super.key});

  @override
  State<TabsPagePatient> createState() => _TabsPagePatientState();
}

class _TabsPagePatientState extends State<TabsPagePatient> {
  final List<Map<String, Object>> _indexScreen = [
    {
      'title': '',
      'screen': const HomePatientPage(),
    },
    {
      'title': '',
      'screen': const ChatPatientPage(),
    },
    {
      'title': '',
      'screen': const PatientProfilePage(),
    },
    {
      'title': '',
      'screen': const ExercisesPage(),
    }
  ];

  @override
  Widget build(BuildContext context) {
    final indexProvider = Provider.of<BottomNavBarPatientController>(context);
    return Scaffold(
      body: _indexScreen.elementAt(indexProvider.index)['screen']! as Widget,
      floatingActionButton: const BottomNavBarPatient(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
