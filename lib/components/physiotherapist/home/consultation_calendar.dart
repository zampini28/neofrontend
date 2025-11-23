import 'package:flutter/material.dart';
import 'package:physioapp/components/physiotherapist/home/grid_day_calendar.dart';

class ConsultationCalendar extends StatelessWidget {
  const ConsultationCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 328,
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomStart,
          colors: [
            Color.fromARGB(255, 223, 224, 234),
            Color.fromARGB(255, 233, 235, 240),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Consultas por dia',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          // Text(
          //   '9 de 12 completas',
          //   style: TextStyle(
          //     fontWeight: FontWeight.w400,
          //     fontSize: 12,
          //     color: Theme.of(context).textTheme.labelSmall?.color,
          //   ),
          // ),
          SizedBox(height: 15),
          Expanded(
            child: GridDayCalendar(),
          ),
        ],
      ),
    );
  }
}
