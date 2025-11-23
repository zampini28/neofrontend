import 'package:flutter/material.dart';
import 'package:physioapp/services/navigation/bottom_nav_bar_controller.dart';
import 'package:provider/provider.dart';

class BottomNavBarPhysio extends StatefulWidget {
  const BottomNavBarPhysio({
    super.key,
  });

  @override
  BottomNavBarPhysioState createState() => BottomNavBarPhysioState();
}

class BottomNavBarPhysioState extends State<BottomNavBarPhysio> {
  Widget _buttomIcons({
    required IconData icon,
    required int index,
    required BottomNavBarPhysioController currentPage,
  }) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: currentPage.index == index
              ? Theme.of(context).primaryColor
              : Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: IconButton(
          onPressed: () => currentPage.toggleIndex(index: index),
          icon: Icon(
            icon,
            color: currentPage.index == index
                ? Colors.white
                : Theme.of(context).textTheme.labelLarge?.color,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = Provider.of<BottomNavBarPhysioController>(context);
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
            index: 0,
            currentPage: currentPage,
          ),
          _buttomIcons(
            icon: Icons.chat_bubble_rounded,
            index: 1,
            currentPage: currentPage,
          ),
          _buttomIcons(
            icon: Icons.auto_awesome_mosaic_rounded,
            index: 2,
            currentPage: currentPage,
          ),
          _buttomIcons(
            icon: Icons.person,
            index: 3,
            currentPage: currentPage,
          ),
          _buttomIcons(
            icon: Icons.add_circle_outlined,
            index: 4,
            currentPage: currentPage,
          ),
        ],
      ),
    );
  }
}
