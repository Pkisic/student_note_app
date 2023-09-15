import 'package:diplomski/models/note.dart';
import 'package:flutter/material.dart';

class NotesSearchResultView extends StatelessWidget {
  final List<Note> notes;

  const NotesSearchResultView({
    Key? key,
    required this.notes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return ListTile(
          title: Text(note.title),
          subtitle: Text(note.title),
        );
      },
    );
  }
}
