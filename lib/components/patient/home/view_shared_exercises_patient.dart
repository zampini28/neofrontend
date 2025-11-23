import 'package:flutter/material.dart';
import 'package:physioapp/components/patient/home/shared_exercise_item_patient.dart';

class ViewSharedExercisesPatient extends StatefulWidget {
  const ViewSharedExercisesPatient({super.key});

  @override
  State<ViewSharedExercisesPatient> createState() =>
      _ViewSharedExercisesPatientState();
}

class _ViewSharedExercisesPatientState
    extends State<ViewSharedExercisesPatient> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {},
                child: const Text('Ver todos'),
              ),
            ],
          ),
          Flexible(
            fit: FlexFit.loose,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: 2,
              itemBuilder: (context, index) {
                return const SharedExerciseItemPatient();
              },
            ),
          ),
        ],
      ),
    );
  }
}
