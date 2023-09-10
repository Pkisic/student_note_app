import 'package:diplomski/services/notes_service.dart';

class Note {
  final int id;
  final String title;
  final String text;
  late int category;
  late NotesService service;

  Note({
    required this.id,
    required this.title,
    required this.text,
    required this.category,
  });

  Note.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        title = map[titleColumn] as String,
        text = map[textColumn] as String,
        category = map[categoryColumn] as int;

  @override
  String toString() => 'Note, ID = $id, TITLE = $title, Category = $category';

  @override
  bool operator ==(covariant Note other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
