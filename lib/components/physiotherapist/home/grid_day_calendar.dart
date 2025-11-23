import 'package:flutter/material.dart';

class GridDayCalendar extends StatefulWidget {
  const GridDayCalendar({super.key});

  @override
  GridDayCalendarState createState() => GridDayCalendarState();
}

class GridDayCalendarState extends State<GridDayCalendar> {
  final now = DateTime.now();
  int get daysInMonth => DateTime(now.year, now.month + 1, 0).day;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: daysInMonth,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemBuilder: (context, index) => Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: Text(
            '${index + 1}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
