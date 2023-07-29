import 'package:diplomski/models/note.dart';
import 'package:diplomski/utilities/dialogs/delete_dialog.dart';
import 'package:flutter/material.dart';

typedef NoteCallback = void Function(Note note);

class NotesListView extends StatelessWidget {
  final List<Note> notes;
  final NoteCallback onDeleteNote;
  final NoteCallback onTap;

  const NotesListView({
    Key? key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return Dismissible(
          key: Key(note.toString()),
          onDismissed: (direction) {
            if ((direction == DismissDirection.startToEnd)) {
              onDeleteNote(note);
              final snack = SnackBar(
                content: const Text('Note deleted!'),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {},
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snack);
            } else {}
          },
          confirmDismiss: (direction) async {
            if ((direction == DismissDirection.startToEnd)) {
              return await showDeleteDialog(context);
            } else {
              return false;
            }
          },
          background: Container(
            color: Colors.red,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  Text(
                    'Delete note',
                    style: Theme.of(context).textTheme.bodyMedium,
                  )
                ],
              ),
            ),
          ),
          secondaryBackground: Container(
            color: Colors.green,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.archive,
                    color: Colors.white,
                  ),
                  Text('Move to archive'),
                ],
              ),
            ),
          ),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              onTap: () {
                onTap(note);
              },
              title: Text(note.title),
              subtitle: Text(note.text),
              isThreeLine: true,
              tileColor: Colors.blueGrey[900],
              textColor: Colors.white,
              iconColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        );
      },
    );
  }
}
