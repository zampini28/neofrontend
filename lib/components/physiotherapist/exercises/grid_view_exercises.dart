import 'package:flutter/material.dart';
import 'package:physioapp/components/physiotherapist/exercises/box_exercises_type.dart';
import 'package:physioapp/services/exercises/physio/category_controller.dart';

class GridViewExercises extends StatelessWidget {
  const GridViewExercises({super.key});

  @override
  Widget build(BuildContext context) {
    final categoriesExercises = CategoryController();
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 3.2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemBuilder: (context, index) => BoxExercisesType(
        category: categoriesExercises.listCategory.elementAt(index),
      ),
      itemCount: categoriesExercises.itemsCount,
    );
  }
}
