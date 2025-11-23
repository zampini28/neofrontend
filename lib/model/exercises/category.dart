import 'package:flutter/material.dart';

enum CategoryId {
  legs,
  abdominal,
  back,
  arms,
  favorites,
  personalized,
}

class Category {
  final CategoryId id;
  final String title;
  final String subtitle;
  final Color color;

  const Category({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.color,
  });
}
