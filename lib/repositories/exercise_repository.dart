import 'package:flutter/material.dart';
import 'package:physioapp/model/exercises/exercise.dart';
import 'package:provider/provider.dart';
import 'package:physioapp/core/network/api_client.dart';

class ExerciseRepository {
  final ApiClient _api;
  ExerciseRepository(this._api);

  Future<List<Exercise>> getExercises() async {
    final response = await _api.client.get('/exercises');
    return (response.data as List).map((e) => Exercise.fromJson(e as Map<String, dynamic>)).toList();
  }
}

class ExerciseProvider with ChangeNotifier {
  final ExerciseRepository _repo;
  List<Exercise> _items = [];
  bool isLoading = false;

  ExerciseProvider(this._repo);

  Future<void> fetchExercises() async {
    isLoading = true;
    notifyListeners();
    try {
      _items = await _repo.getExercises();
    } catch (e) {
      debugPrint('-- failed in fetchExercises: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
