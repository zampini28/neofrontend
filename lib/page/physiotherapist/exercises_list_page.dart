import 'package:flutter/material.dart';
import 'package:physioapp/components/physiotherapist/exercises/exercises_list.dart';
import 'package:physioapp/model/exercises/category.dart';
import 'package:physioapp/services/exercises/physio/exercise_controller.dart';
import 'package:physioapp/services/navigation/bottom_nav_bar_controller.dart';
import 'package:physioapp/utils/app_routes.dart';
import 'package:provider/provider.dart';

class ExercisesListPage extends StatelessWidget {
  const ExercisesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final category = ModalRoute.of(context)!.settings.arguments! as Category;
    final exercises = Provider.of<ExerciseController>(context);
    // Filtrando por categoria
    final filteredList = exercises.listExercises.where(
      (exe) => exe.categoryId.contains(category.id),
    );
    final navigationPage = Provider.of<BottomNavBarPhysioController>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              AppRoutes.tabPagePhysio,
              (route) => false,
            );
            navigationPage.toggleIndex(index: 2);
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
          ),
        ),
        title: Text(category.title),
      ),
      body: Container(
        width: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView.builder(
          itemBuilder: (context, index) => ExercisesList(
            exercise: category.id == exercises.favoriteCategory
                ? exercises.listFavorites.elementAt(index)
                : filteredList.elementAt(index),
          ),
          itemCount: category.id == exercises.favoriteCategory
              ? exercises.listFavorites.length
              : filteredList.length,
        ),
      ),
    );
  }
}
