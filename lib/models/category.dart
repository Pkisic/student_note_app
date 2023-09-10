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

  factory Category.none(Color color) {
    return NoneCategory(color);
  }

  Category.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        name = map[nameColumn] as String,
        description = map[descriptionColumn] as String,
        color = Color(map[colorColumn] as int);

  @override
  String toString() {
    return "Category{id=$id, name='$name', color = '$color', description = '$description' ";
  }

  @override
  bool operator ==(dynamic other) =>
      other != null && other is Category && id == other.id;

  @override
  int get hashCode => super.hashCode;
}

class NoneCategory extends Category {
  NoneCategory(Color color)
      : super(
          id: -1,
          name: 'Uncategorized',
          color: color,
          description: 'Uncategorized',
        );
}
