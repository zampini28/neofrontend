import 'package:flutter/material.dart';
import 'package:physioapp/components/physiotherapist/exercises/list_steps_exercises.dart';
import 'package:physioapp/exception/auth_signup_exception.dart';
import 'package:physioapp/services/exercises/physio/exercises_controller_form.dart';
import 'package:provider/provider.dart';

class FirstAddExerciseForm extends StatefulWidget {
  const FirstAddExerciseForm({super.key});

  @override
  State<FirstAddExerciseForm> createState() => _FirstAddExerciseFormState();
}

class _FirstAddExerciseFormState extends State<FirstAddExerciseForm> {
  final _formKey = GlobalKey<FormState>();

  void _validateForm({required ExercisesControllerForm exerciseFormProvider}) {
    final authException = AuthSignupException();
    final isValid = _formKey.currentState?.validate() ?? false;

    if (isValid == false) {
      return;
    }

    if (exerciseFormProvider.titleExercise!.isEmpty) {
      return authException.showErrorValidate(
        message: 'Digite um título para o exercício',
        context: context,
      );
    }

    if (exerciseFormProvider.descriptionExercise!.isEmpty) {
      return authException.showErrorValidate(
        message: 'Digite uma descrição para o exercício',
        context: context,
      );
    }

    if (exerciseFormProvider.titleStep!.isEmpty) {
      return authException.showErrorValidate(
        message: 'Digite um título para a etapa do exercício',
        context: context,
      );
    }

    if (exerciseFormProvider.descriptionStep!.isEmpty) {
      return authException.showErrorValidate(
        message: 'Digite uma descrição para a etapa do exercício',
        context: context,
      );
    }

    if (exerciseFormProvider.getNextForm == true) {
      exerciseFormProvider.addStep(
        titleStep: exerciseFormProvider.titleStep ?? '',
        descriptionStep: exerciseFormProvider.descriptionStep ?? '',
      );

      exerciseFormProvider.advanceForm();
    }
  }

  @override
  Widget build(BuildContext context) {
    final exerciseFormProvider = Provider.of<ExercisesControllerForm>(context);

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

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Text(
            'Informações do Exercício',
            style: TextStyle(
              color: Theme.of(context).textTheme.labelLarge?.color,
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          defaultTextForm(
            textForm: TextFormField(
              decoration: InputDecoration(
                label: Text(
                  'Título do exercício',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.labelLarge?.color,
                  ),
                ),
                border: InputBorder.none,
              ),
              onChanged: (title) => exerciseFormProvider.titleExercise = title,
              keyboardType: TextInputType.text,
            ),
          ),
          defaultTextForm(
            textForm: TextFormField(
              decoration: InputDecoration(
                label: Text(
                  'Descrição do exercício',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.labelLarge?.color,
                  ),
                ),
                border: InputBorder.none,
              ),
              onChanged: (description) => exerciseFormProvider.descriptionExercise = description,
              keyboardType: TextInputType.multiline,
              maxLines: 3,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 6),
            child: Text(
              'Etapas do Exercício',
              style: TextStyle(
                color: Theme.of(context).textTheme.labelLarge?.color,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(
            height: exerciseFormProvider.quantitySteps * 180,
            child: ListView.builder(
              itemCount: exerciseFormProvider.quantitySteps,
              itemBuilder: (context, index) {
                return const ListStepsExercises();
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.only(top: 10),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        Theme.of(context).colorScheme.tertiary,
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    onPressed: () {
                      exerciseFormProvider.addLenghtListStep();

                      exerciseFormProvider.addStep(
                        titleStep: exerciseFormProvider.titleStep ?? '',
                        descriptionStep: exerciseFormProvider.descriptionStep ?? '',
                      );
                    },
                    child: const Text(
                      'Adicionar Etapa',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.only(top: 10),
                  child: ElevatedButton.icon(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        exerciseFormProvider.getNextForm
                            ? Theme.of(context).colorScheme.tertiary
                            : Colors.grey,
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    onPressed: () => _validateForm(
                      exerciseFormProvider: exerciseFormProvider,
                    ),
                    label: const Text(
                      'Concluir',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    icon: const Icon(
                      Icons.add_task_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
