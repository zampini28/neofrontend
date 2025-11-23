import 'package:flutter/material.dart';
import 'package:physioapp/components/physiotherapist/navigation/app_drawer.dart';
import 'package:physioapp/components/physiotherapist/navigation/bottom_nav_bar_physio.dart';
import 'package:physioapp/page/physiotherapist/chat_page_physio.dart';
import 'package:physioapp/page/physiotherapist/exercises_page_physio.dart';
import 'package:physioapp/page/physiotherapist/home_physio_page.dart';
import 'package:physioapp/page/physiotherapist/physio_profile_page.dart';
import 'package:physioapp/page/physiotherapist/schedule_appointment_page.dart';
import 'package:physioapp/services/navigation/bottom_nav_bar_controller.dart';
import 'package:provider/provider.dart';

class TabsPagePhysio extends StatefulWidget {
  const TabsPagePhysio({super.key});

  @override
  State<TabsPagePhysio> createState() => _TabsPagePhysioState();
}

class _TabsPagePhysioState extends State<TabsPagePhysio> {
  final List<Map<String, Object>> _indexScreen = [
    {
      'title': '',
      'screen': const HomePhysioPage(),
    },
    {
      'title': '',
      'screen': const ChatPagePhysio(),
    },
    {
      'title': '',
      'screen': const ExercisesPagePhysio(),
    },
    {
      'title': '',
      'screen': const PhysioProfilePage(),
    },
    {
      'title': '',
      'screen': const ScheduleAppointmentPage(),
    }
  ];

  @override
  Widget build(BuildContext context) {
    final indexProvider = Provider.of<BottomNavBarPhysioController>(context);
    return Scaffold(
      body: _indexScreen.elementAt(indexProvider.index)['screen']! as Widget,
      floatingActionButton: const BottomNavBarPhysio(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      drawer: const AppDrawer(),
    );
  }
}
