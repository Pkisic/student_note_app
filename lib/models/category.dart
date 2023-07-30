import 'package:diplomski/services/notes_service.dart';
import 'package:flutter/material.dart';

class Category {
  final int id;
  final String name;
  final Color color;
  final String? description;

  Category(
    this.description, {
    required this.id,
    required this.name,
    required this.color,
  });

  Category.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        name = map[nameColumn] as String,
        description = map[descriptionColumn] as String,
        color = map[colorColumn] as Color;
}
