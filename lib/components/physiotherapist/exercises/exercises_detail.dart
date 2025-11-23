import 'package:flutter/material.dart';
import 'package:physioapp/model/exercises/exercise.dart';
import 'package:physioapp/services/exercises/physio/exercise_controller.dart';
import 'package:provider/provider.dart';

class ExercisesDetail extends StatelessWidget {
  final Exercise exercise;
  const ExercisesDetail({
    super.key,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context) {
    final exerciseProvider = Provider.of<ExerciseController>(context);
    return Card(
      color: const Color.fromARGB(255, 236, 236, 236),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      shape: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(28),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: ListTile(
                title: Text(
                  exercise.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily:
                        Theme.of(context).textTheme.titleSmall?.fontFamily,
                    fontSize: Theme.of(context).textTheme.titleSmall?.fontSize,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  exercise.description,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.share_outlined),
            ),
            IconButton(
              onPressed: () {
                exerciseProvider.toggleFavorite(exerciseId: exercise.id);
              },
              icon: exercise.isFavorite
                  ? const Icon(Icons.favorite_rounded)
                  : const Icon(Icons.favorite_border_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
