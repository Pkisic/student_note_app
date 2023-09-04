import 'dart:ffi';

import 'package:diplomski/services/notes_service.dart';
import 'package:flutter/material.dart';

class Category {
  final int id;
  final String name;
  final Color color;
  final String? description;

  Category({
    required this.id,
    required this.name,
    required this.color,
    required this.description,
  });

  Category.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        name = map[nameColumn] as String,
        description = map[descriptionColumn] as String,
        color = Color(map[colorColumn] as int);
}
