import 'package:flutter/material.dart';

class SharedExerciseItemPatient extends StatefulWidget {
  const SharedExerciseItemPatient({super.key});

  @override
  State<SharedExerciseItemPatient> createState() =>
      _SharedExerciseItemPatientState();
}

class _SharedExerciseItemPatientState extends State<SharedExerciseItemPatient> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      margin: const EdgeInsets.symmetric(horizontal: 3),
      child: Card(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Image.asset(
                'assets/images/background_image_auth_physio.png',
                height: 160,
                width: 280,
                fit: BoxFit.cover,
              ),
            ),
            Text(
              'Nome do exercício',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Theme.of(context).textTheme.labelLarge?.color,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.access_time_filled_rounded,
                  color: Theme.of(context).textTheme.labelLarge?.color,
                ),
                Text(
                  '13 min',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.labelLarge?.color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
