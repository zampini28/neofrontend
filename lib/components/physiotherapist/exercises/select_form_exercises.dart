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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Radio(
            value: widget.exerciseForm.getFirstForm,
            groupValue: widget.exerciseForm.currentForm,
            onChanged: (value) {}),
        Radio(
            value: widget.exerciseForm.getSecondForm,
            groupValue: widget.exerciseForm.currentForm,
            onChanged: (value) {}),
      ],
    );
  }
}
