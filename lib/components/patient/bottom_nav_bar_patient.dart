import 'package:flutter/material.dart';
import 'package:physioapp/services/navigation/bottom_nav_bar_patient_controller.dart';
import 'package:provider/provider.dart';

class BottomNavBarPatient extends StatefulWidget {
  const BottomNavBarPatient({
    super.key,
  });

  @override
  BottomNavBarPatientState createState() => BottomNavBarPatientState();
}

class BottomNavBarPatientState extends State<BottomNavBarPatient> {
  Widget _buttomIcons(
      {required IconData icon,
      required int indexPage,
      required BottomNavBarPatientController currentIndex}) {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: currentIndex.index == indexPage
            ? Theme.of(context).primaryColor
            : Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: IconButton(
        onPressed: () {
          currentIndex.toggleIndex(index: indexPage);
        },
        icon: Icon(
          icon,
          color: currentIndex.index == indexPage
              ? Colors.white
              : Theme.of(context).textTheme.labelLarge?.color,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = Provider.of<BottomNavBarPatientController>(context);
    return Container(
      width: 380,
      height: 76,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buttomIcons(
            icon: Icons.home_filled,
            indexPage: 0,
            currentIndex: currentPage,
          ),
          _buttomIcons(
            icon: Icons.chat_bubble_rounded,
            indexPage: 1,
            currentIndex: currentPage,
          ),
          _buttomIcons(
            icon: Icons.person,
            indexPage: 2,
            currentIndex: currentPage,
          ),
          _buttomIcons(
            icon: Icons.auto_awesome_mosaic_rounded,
            indexPage: 3,
            currentIndex: currentPage,
          ),
        ],
      ),
    );
  }
}
