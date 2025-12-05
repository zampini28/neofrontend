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

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        spacing: 10,
        children: [
          Row(
            children: [
              Expanded(
                child: defaultTextForm(
                  textForm: TextFormField(
                    key: ValueKey('title_$index'),
                    initialValue: step.title,
                    decoration: InputDecoration(
                      label: Text('Título da Etapa',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.color)),
                      border: InputBorder.none,
                    ),
                    onChanged: (val) =>
                        exercisesFormProvider.updateStep(index, title: val),
                  ),
                ),
              ),
              if (exercisesFormProvider.quantitySteps > 1)
                IconButton(
                  onPressed: () => exercisesFormProvider.removeStep(index),
                  icon: const Icon(Icons.delete_outline_rounded,
                      color: Colors.red),
                ),
            ],
          ),

          defaultTextForm(
            textForm: TextFormField(
              key: ValueKey('desc_$index'),
              initialValue: step.description,
              decoration: InputDecoration(
                label: Text('Descrição da Etapa',
                    style: TextStyle(
                        color: Theme.of(context).textTheme.labelLarge?.color)),
                border: InputBorder.none,
              ),
              maxLines: 3,
              onChanged: (val) =>
                  exercisesFormProvider.updateStep(index, description: val),
            ),
          ),
        ],
      ),
    );
  }
}
