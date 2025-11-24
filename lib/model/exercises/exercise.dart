import 'package:flutter/material.dart';
import 'package:physioapp/model/exercises/category.dart';
import 'package:physioapp/services/exercises/physio/exercises_controller_form.dart';

class Exercise with ChangeNotifier {
  final String id;
  final String name;
  final String description;
  final String videoUrl;
  final double videoDuration;
  final List<StepModel> steps;
  final List<CategoryId> categoryId;
  bool isFavorite;

  Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.videoUrl,
    required this.videoDuration,
    required this.steps,
    required this.categoryId,
    this.isFavorite = false,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      videoUrl: json['videoUrl'] as String,
      videoDuration: json['videoDuration'] as double,
      steps: (json['steps'] as List)
          .map((step) => StepModel(title: step['title'] as String, description: step['description'] as String))
          .toList(),
      categoryId: (json['categoryId'] as List)
          .map((id) => CategoryId.values.firstWhere((e) => e.toString() == 'CategoryId.$id'))
          .toList(),
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
