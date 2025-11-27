import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:physioapp/data/exercises_mock_data.dart';
import 'package:physioapp/model/exercises/category.dart';
import 'package:physioapp/model/exercises/exercise.dart';
import 'package:physioapp/services/auth/auth.dart';
import 'package:physioapp/services/exercises/physio/exercises_controller_form.dart';
import 'package:physioapp/utils/domain_connection.dart';

class ExerciseController with ChangeNotifier {
  final List<Exercise> _listExercises = ExercisesMockData().exercisesList;

  List<Exercise> get listExercises => [..._listExercises];

  List<Exercise> get listFavorites =>
      _listExercises.where((exercise) => exercise.isFavorite == true).toList();

  int get itemsAcount => _listExercises.length;

  CategoryId get favoriteCategory => CategoryId.favorites;

  Future<void> fetchPersonalizedExercises() async {
    final url = Uri.parse('${DomainConnection().url}/exercises');
    final token = await getToken();

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        _processExercisesResponse(response.body);
      }
    } catch (e) {
      debugPrint('Error fetching physio exercises: $e');
    }
  }

  Future<void> fetchPatientExercises() async {
    final baseUrl = DomainConnection().url;
    final token = await getToken();

    try {
      final relResponse = await http.get(
        Uri.parse('$baseUrl/api/relationships'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (relResponse.statusCode != 200) {
        debugPrint('Failed to fetch relationships: ${relResponse.statusCode}');
        return;
      }

      final List<dynamic> relationships = jsonDecode(relResponse.body) as List<dynamic>;

      final physioIds = relationships
          .where((r) => (r['type'] ?? '').toString().toUpperCase() == 'PHYSIO')
          .map((r) => r['id'].toString())
          .toList();

      if (physioIds.isEmpty) {
        debugPrint('No connected physiotherapists found.');
        return;
      }

      final List<Exercise> allPatientExercises = [];

      for (final physioId in physioIds) {
        final exResponse = await http.get(
          Uri.parse('$baseUrl/exercises/physiotherapist/$physioId'),
          headers: {'Authorization': 'Bearer $token'},
        );

        if (exResponse.statusCode == 200) {
          final List<dynamic> data = jsonDecode(exResponse.body) as List<dynamic>;
          final exercises =
              data.map((json) => Exercise.fromJson(json as Map<String, dynamic>)).toList();
          allPatientExercises.addAll(exercises);
        }
      }

      _listExercises.removeWhere((ex) => ex.categoryId.contains(CategoryId.personalized));
      _listExercises.addAll(allPatientExercises);
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching patient exercises: $e');
    }
  }

  void _processExercisesResponse(String body) {
    final List<dynamic> data = jsonDecode(body) as List<dynamic>;
    _listExercises.removeWhere((ex) => ex.categoryId.contains(CategoryId.personalized));
    final newExercises =
        data.map((json) => Exercise.fromJson(json as Map<String, dynamic>)).toList();
    _listExercises.addAll(newExercises);
    notifyListeners();
  }

  void addExercises({required ExercisesControllerForm formExercise}) {}

  void toggleFavorite({required String exerciseId}) {
    final exerciseLocalized = _listExercises.firstWhere((exercise) => exercise.id == exerciseId);
    exerciseLocalized.isFavorite = !exerciseLocalized.isFavorite;
    notifyListeners();
  }
}
