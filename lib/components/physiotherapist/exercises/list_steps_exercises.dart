import 'package:flutter/material.dart';
import 'package:physioapp/services/exercises/physio/exercises_controller_form.dart';
import 'package:provider/provider.dart';

class StepExercise extends StatelessWidget {
  const StepExercise({super.key, required this.index});

  final int index;

  Widget defaultTextForm({required Widget textForm}) {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: textForm,
    );
  }

  @override
  Widget build(BuildContext context) {
    final exercisesFormProvider = Provider.of<ExercisesControllerForm>(context);

    final step = exercisesFormProvider.steps[index];

    return SizedBox(
      height: 180,
      child: Column(
        spacing: 10,
        children: [
          defaultTextForm(
            textForm: TextFormField(
              initialValue: step.title,
              decoration: InputDecoration(
                label: Text(
                  'Título da Etapa',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.labelLarge?.color,
                  ),
                ),
                border: InputBorder.none,
              ),
              keyboardType: TextInputType.text,
              onChanged: (value) {
                exercisesFormProvider.updateStep(
                  index,
                  title: value,
                );
              },
            ),
          ),
          defaultTextForm(
            textForm: TextFormField(
              initialValue: step.description,
              decoration: InputDecoration(
                label: Text(
                  'Descrição da Etapa',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.labelLarge?.color,
                  ),
                ),
                border: InputBorder.none,
              ),
              keyboardType: TextInputType.text,
              maxLines: 3,
              onChanged: (value) {
                exercisesFormProvider.updateStep(
                  index,
                  description: value,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
