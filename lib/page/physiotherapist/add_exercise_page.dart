import 'package:flutter/material.dart';
import 'package:physioapp/components/physiotherapist/exercises/first_add_exercise_form.dart';
import 'package:physioapp/components/physiotherapist/exercises/second_add_exercise_form.dart';
import 'package:physioapp/components/physiotherapist/exercises/select_form_exercises.dart';
import 'package:physioapp/services/exercises/physio/exercises_controller_form.dart';
import 'package:physioapp/services/navigation/bottom_nav_bar_controller.dart';
import 'package:physioapp/utils/app_routes.dart';
import 'package:provider/provider.dart';

class AddExercisePage extends StatelessWidget {
  const AddExercisePage({super.key});

  @override
  Widget build(BuildContext context) {
    final exerciseFormProvider = Provider.of<ExercisesControllerForm>(context);
    final navigationPage = Provider.of<BottomNavBarPhysioController>(context);

    void showConfirmForm() {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog.adaptive(
              title: const Text('Avançar?'),
              content: const Text(
                  'Após processeguir você não poderá retornar a edição das etapas'),
              actions: [
                TextButton(
                  onPressed: () {
                    exerciseFormProvider.toggleForm(
                      valueForm: exerciseFormProvider.getSecondForm,
                    );

                    Navigator.of(context).pop();
                  },
                  child: const Text('Sim'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Não'),
                ),
              ],
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              AppRoutes.tabPagePhysio,
              (route) => false,
            );
            navigationPage.toggleIndex(index: 2);
            exerciseFormProvider.resetSteps();
            exerciseFormProvider.toggleForm(
                valueForm: exerciseFormProvider.getFirstForm);
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
          ),
        ),
        title: const Text('Adicionar Exercício'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 60,
              ),
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
                top: 16,
                bottom: 24,
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
              child: Column(
                children: [
                  if (exerciseFormProvider.firstForm) const FirstAddExerciseForm(),
                  if (exerciseFormProvider.secondForm)
                    const SecondAddExerciseForm(),
                  const SizedBox(height: 10),
                  SelectFormExercises(
                    exerciseForm: exerciseFormProvider,
                  ),
                  Row(
                    mainAxisAlignment: exerciseFormProvider.firstForm
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      if (exerciseFormProvider.firstForm)
                        TextButton(
                          onPressed: () {
                            if (exerciseFormProvider.getEnableNextButton) {
                              showConfirmForm();
                            }
                          },
                          child: Text(
                            'Proximo',
                            style: TextStyle(
                              color: exerciseFormProvider.getEnableNextButton
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey,
                            ),
                          ),
                        )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
