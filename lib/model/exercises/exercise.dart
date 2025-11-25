import 'package:flutter/material.dart';
import 'package:physioapp/model/exercises/category.dart';
import 'package:physioapp/utils/domain_connection.dart';

class Exercise with ChangeNotifier {
  final String id;
  final String name;
  final String description;
  final String videoUrl;
  final List<Map<String, String>> steps;
  final double videoDuration;
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

  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  factory Exercise.fromJson(Map<String, dynamic> json) {
    double duration = 0.0;
    final rawDuration = json['videoDuration'] as String? ?? '0 min';

    if (rawDuration.contains('sec')) {
      final sec = int.tryParse(rawDuration.split(' ')[0]) ?? 0;
      duration = sec / 60.0;
    } else if (rawDuration.contains('min')) {
      final min = double.tryParse(rawDuration.split(' ')[0]) ?? 0.0;
      duration = min;
    }

    final List<Map<String, String>> parsedSteps = [];
    if (json['steps'] != null) {
      for (final step in json['steps'] as List) {
        parsedSteps.add({step['title'] as String: step['description'] as String});
      }
    }

    final videoEndpoint = '${DomainConnection().url}/exercises/${json['id']}/video';

    return Exercise(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      videoUrl: videoEndpoint,
      videoDuration: duration,
      steps: parsedSteps,
      categoryId: [CategoryId.personalized],
    );
  }
}
