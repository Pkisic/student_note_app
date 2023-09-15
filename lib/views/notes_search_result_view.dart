import 'package:diplomski/models/note.dart';
import 'package:flutter/material.dart';

class NotesSearchResultView extends StatelessWidget {
  final List<Note> notes;
  final String query;

  const NotesSearchResultView({
    Key? key,
    required this.notes,
    required this.query,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return ListTile(
          title: textSelection(note.title),
          subtitle: textSelection(note.text),
        );
      },
    );
  }

  RichText textSelection(String text) {
    final List<TextSpan> spans = [];
    var loweredText = text.toLowerCase().replaceAll('\n', ' ');
    var loweredQuery = query.toLowerCase();
    var start = loweredText.indexOf(loweredQuery);
    if (start < 0) {
      return RichText(text: TextSpan(children: [TextSpan(text: text)]));
    }
    spans.add(
      TextSpan(
        text: text.substring(0, start),
        style: const TextStyle(color: Colors.white),
      ),
    );
    spans.add(
      TextSpan(
        text: text.substring(start, start + query.length),
        style: const TextStyle(color: Colors.amber),
      ),
    );
    spans.add(
      TextSpan(
        text: text.substring(start + query.length),
        style: const TextStyle(color: Colors.white),
      ),
    );
    return RichText(
      text: TextSpan(
        children: spans,
      ),
    );
  }
}
