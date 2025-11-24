import 'package:flutter/material.dart';
import 'package:physioapp/components/physiotherapist/exercises/add_video_box.dart';
import 'package:physioapp/components/physiotherapist/exercises/time_input_formatter.dart';
import 'package:physioapp/exception/auth_signup_exception.dart';
import 'package:physioapp/services/auth/auth.dart';
import 'package:physioapp/services/exercises/physio/exercise_controller.dart';
import 'package:physioapp/services/exercises/physio/exercises_controller_form.dart';
import 'package:physioapp/services/navigation/bottom_nav_bar_controller.dart';
import 'package:physioapp/utils/app_routes.dart';
import 'package:provider/provider.dart';

class SecondAddExerciseForm extends StatefulWidget {
  const SecondAddExerciseForm({super.key});

  @override
  State<SecondAddExerciseForm> createState() => _SecondAddExerciseFormState();
}

class _SecondAddExerciseFormState extends State<SecondAddExerciseForm> {
  Future<void> _submitFormAddExercise({required ExercisesControllerForm formExercise}) async {
    if (!formExercise.videoSelected) {
      return AuthSignupException().showErrorValidate(
        message: 'Selecione um vídeo.',
        context: context,
      );
    }

    final bool isUpdated = await updateExerciseToServer(formExercise: formExercise);

    if (!isUpdated) {
      return AuthSignupException().showErrorValidate(
        message: 'Erro ao atualizar o exercício.',
        context: context,
      );
    }

    formExercise.resetSteps();
    formExercise.toggleSecondForm();

    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.tabPagePhysio,
      (_) => false,
    );

    // navigationPage.toggleIndex(index: 2);
    // formExercise.toggleForm(valueForm: formExercise.getFirstForm);
    // exerciseController.addExercises(formExercise: formExercise);
  }

  @override
  Widget build(BuildContext context) {
    final exercisesFormProvider = Provider.of<ExercisesControllerForm>(context);

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
      child: Column(
        spacing: 10,
        children: [
          Text(
            'Informações do Exercício',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).textTheme.labelLarge?.color,
            ),
          ),
          AddVideoBox(formProvider: exercisesFormProvider),
          Container(
            width: double.infinity,
            height: 50,
            margin: const EdgeInsets.only(top: 10),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  exercisesFormProvider.videoSelected
                      ? Theme.of(context).colorScheme.tertiary
                      : Colors.grey,
                ),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              onPressed: () {
                if (exercisesFormProvider.videoSelected) {
                  _submitFormAddExercise(formExercise: exercisesFormProvider);
                }
              },
              child: const Text(
                'Adicionar Exercício',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
