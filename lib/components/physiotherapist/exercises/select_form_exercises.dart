import 'package:flutter/material.dart';
import 'package:physioapp/services/exercises/physio/exercises_controller_form.dart';

class SelectFormExercises extends StatefulWidget {
  final ExercisesControllerForm exerciseForm;
  const SelectFormExercises({super.key, required this.exerciseForm});

  @override
  State<SelectFormExercises> createState() => _SelectFormExercisesState();
}

class _SelectFormExercisesState extends State<SelectFormExercises> {
  @override
  Widget build(BuildContext context) {
    return 
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Radio<bool>(
          value: false,
          groupValue: widget.exerciseForm.secondForm,
          onChanged: (bool? value) {
          },
        ),
        Radio<bool>(
          value: true,
          groupValue: widget.exerciseForm.secondForm,
          onChanged: (value) {
          },
        ),
      ],
    );
  }
}
