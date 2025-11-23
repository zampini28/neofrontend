import 'package:flutter/material.dart';
import 'package:physioapp/components/physiotherapist/exercises/exercises_detail.dart';
import 'package:physioapp/components/physiotherapist/exercises/exercises_steps.dart';
import 'package:physioapp/components/physiotherapist/exercises/video_box.dart';
import 'package:physioapp/model/exercises/exercise.dart';

class ExercisesDetailPage extends StatelessWidget {
  const ExercisesDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final exercise = ModalRoute.of(context)!.settings.arguments! as Exercise;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(exercise.name),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                width: double.infinity,
                height: 250,
                child: VideoBox(),
              ),
              ExercisesDetail(
                exercise: exercise,
              ),
              ExerciseSteps(
                exercise: exercise,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
