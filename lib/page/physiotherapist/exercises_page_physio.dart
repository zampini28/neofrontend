import 'package:flutter/material.dart';
import 'package:physioapp/components/physiotherapist/exercises/grid_view_exercises.dart';
import 'package:physioapp/components/physiotherapist/exercises/shared_exercises_view.dart';
import 'package:physioapp/services/exercises/physio/exercises_controller_component.dart';
import 'package:physioapp/utils/app_routes.dart';
import 'package:provider/provider.dart';

class ExercisesPagePhysio extends StatelessWidget {
  const ExercisesPagePhysio({super.key, this.patient = false});

  final bool patient;

  @override
  Widget build(BuildContext context) {
    final exercisesProvider =
        Provider.of<ExercisesControllerComponent>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Exercícios',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontStyle: Theme.of(context).textTheme.headlineMedium?.fontStyle,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              if (exercisesProvider.listComponent.isNotEmpty)
                const SharedExercisesView(),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.74,
                width: double.infinity,
                child: const Padding(
                  padding: EdgeInsets.only(
                    right: 10,
                    left: 10,
                  ),
                  child: GridViewExercises(),
                ),
              ),
              if (!patient)
              Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(AppRoutes.addExercisePage);
                  },
                  child: Text(
                    'Adicionar Exercício',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
              ),
              const SizedBox(
                height: 120,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
