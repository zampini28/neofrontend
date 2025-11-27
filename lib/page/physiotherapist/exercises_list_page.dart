import 'package:flutter/material.dart';
import 'package:physioapp/components/physiotherapist/exercises/exercises_list.dart';
import 'package:physioapp/model/exercises/category.dart';
import 'package:physioapp/services/exercises/physio/exercise_controller.dart';
import 'package:physioapp/services/navigation/bottom_nav_bar_controller.dart';
import 'package:physioapp/utils/app_routes.dart';
import 'package:provider/provider.dart';

class ExercisesListPage extends StatefulWidget {
  const ExercisesListPage({super.key});

  @override
  State<ExercisesListPage> createState() => _ExercisesListPageState();
}

class _ExercisesListPageState extends State<ExercisesListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final category = ModalRoute.of(context)!.settings.arguments! as Category;

      if (category.id == CategoryId.personalized) {
        Provider.of<ExerciseController>(context, listen: false).fetchPersonalizedExercises();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final category = ModalRoute.of(context)!.settings.arguments! as Category;
    final exercisesProvider = Provider.of<ExerciseController>(context);

    final filteredList = exercisesProvider.listExercises
        .where(
          (exe) => exe.categoryId.contains(category.id),
        )
        .toList();

    final displayList = category.id == exercisesProvider.favoriteCategory
        ? exercisesProvider.listFavorites
        : filteredList;

    final navigationPage = Provider.of<BottomNavBarPhysioController>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
            navigationPage.toggleIndex(index: 2);
          },
          icon: const Icon(Icons.arrow_back_ios_rounded),
        ),
        title: Text(category.title),
      ),
      body: Container(
        width: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: displayList.isEmpty
            ? const Center(child: Text('Nenhum exercício encontrado.'))
            : ListView.builder(
                itemBuilder: (context, index) => ExercisesList(
                  exercise: displayList.elementAt(index),
                ),
                itemCount: displayList.length,
              ),
      ),
    );
  }
}
