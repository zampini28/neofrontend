import 'package:flutter/material.dart';
import 'package:physioapp/components/physiotherapist/exercises/step_exercise.dart';
import 'package:physioapp/model/exercises/exercise.dart';

class ExerciseSteps extends StatelessWidget {
  final Exercise exercise;
  const ExerciseSteps({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 350,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Como Fazer o Exercício',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    fontFamily:
                        Theme.of(context).textTheme.titleMedium?.fontFamily,
                  ),
                ),
                Text(
                  '${exercise.steps.length} Passos',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: SizedBox(
              height: 280,
              child: ListView.builder(
                itemCount: exercise.steps.length,
                itemBuilder: (context, index) => StepExercise(
                  indexStep: index + 1,
                  titleStep: exercise.steps.elementAt(index).keys.cast().join(),
                  subtitleStep:
                      exercise.steps.elementAt(index).values.cast().join(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
