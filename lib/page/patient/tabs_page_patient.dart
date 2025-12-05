import 'package:flutter/material.dart';
import 'package:physioapp/components/patient/app_drawer_patient.dart';
import 'package:physioapp/components/patient/bottom_nav_bar_patient.dart';
import 'package:physioapp/page/common/chat_list_page.dart';
import 'package:physioapp/page/patient/exercises_page.dart';
import 'package:physioapp/page/patient/patient_profile_page.dart';
import 'package:physioapp/page/physiotherapist/exercises_page_physio.dart';
import 'package:physioapp/page/physiotherapist/home_physio_page.dart';
import 'package:physioapp/page/physiotherapist/physio_profile_page.dart';
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
      'screen': const HomePhysioPage(),
    },
    {
      'title': 'Chat',
      'screen': const ChatListPage(),
    },
    {
      'title': '',
      'screen': const PhysioProfilePage(patient: true),
    },
    {
      'title': '',
      'screen': const ExercisesPagePhysio(patient: true),
    }
  ];

  @override
  Widget build(BuildContext context) {
    final indexProvider = Provider.of<BottomNavBarPatientController>(context);
    return Scaffold(
      body: _indexScreen.elementAt(indexProvider.index)['screen']! as Widget,
      floatingActionButton: const BottomNavBarPatient(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      drawer: const AppDrawerPatient(),
    );
  }
}
