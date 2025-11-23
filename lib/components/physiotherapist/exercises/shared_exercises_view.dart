import 'package:flutter/material.dart';
import 'package:physioapp/services/exercises/physio/exercises_controller_component.dart';
import 'package:provider/provider.dart';

class SharedExercisesView extends StatefulWidget {
  const SharedExercisesView({super.key});

  @override
  State<SharedExercisesView> createState() => _SharedExercisesViewState();
}

class _SharedExercisesViewState extends State<SharedExercisesView> {
  @override
  Widget build(BuildContext context) {
    final exercises = Provider.of<ExercisesControllerComponent>(context);

    return Container(
      height: 176,
      width: double.infinity,
      padding: const EdgeInsets.only(
        top: 20,
        left: 24,
        right: 24,
        bottom: 10,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 223, 224, 234),
            Color.fromARGB(255, 233, 235, 240),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      child: Column(
        children: [
          const Text(
            'Exercícios compartilhados',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 22,
            ),
          ),
          Container(
            height: 100,
            margin: const EdgeInsets.only(top: 10),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Stack(
                  children: exercises.listComponent.reversed.toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
