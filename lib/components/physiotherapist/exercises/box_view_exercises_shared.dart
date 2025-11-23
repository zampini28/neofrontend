import 'package:flutter/material.dart';
import 'package:physioapp/services/exercises/physio/exercises_controller_component.dart';
import 'package:provider/provider.dart';

class BoxViewExercisesShared extends StatelessWidget {
  const BoxViewExercisesShared({super.key});

  @override
  Widget build(BuildContext context) {
    // Logica de Teste de componente
    final exercises = Provider.of<ExercisesControllerComponent>(context);
    final double listCount = exercises.listComponent.length.toDouble();
    final double marginContainer = (100 * listCount) * 0.3;
    const double opacity50 = 255 * 0.4;

    return exercises.listLength > 3
        ? Container(
            height: 100,
            width: 100,
            margin: EdgeInsets.only(left: marginContainer),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromARGB(opacity50.toInt(), 33, 149, 243),
              border: Border.all(color: Colors.black),
            ),
          )
        : Container(
            height: 100,
            width: 100,
            margin: EdgeInsets.only(left: marginContainer),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(255, 33, 149, 243),
              border: Border.all(color: Colors.black),
            ),
          );
  }
}
