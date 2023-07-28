import 'package:diplomski/models/note.dart';
import 'package:flutter/material.dart';

class NotesListView extends StatelessWidget {
  final List<Note> notes;

  const NotesListView({
    Key? key,
    required this.notes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            title: Text(note.title),
            subtitle: Text("$note"),
            isThreeLine: true,
            tileColor: Colors.blueGrey[900],
            textColor: Colors.white,
            iconColor: Colors.white,
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                final snack = SnackBar(
                  content: const Text('Note deleted!'),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {},
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snack);
              },
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
    );
  }
}
