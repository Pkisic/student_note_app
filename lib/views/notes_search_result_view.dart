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
    var end = loweredText.length;

    RegExp exp = RegExp(loweredQuery);
    Iterable<RegExpMatch> matches = exp.allMatches(loweredText);

    var currentIndex = 0;
    for (var match in matches) {
      var start = match.start;
      var end = match.end;

      if (currentIndex < start) {
        spans.add(
          TextSpan(
            text: text.substring(currentIndex, start),
            style: const TextStyle(color: Colors.white),
          ),
        );
      }

      spans.add(
        TextSpan(
          text: text.substring(start, end),
          style: const TextStyle(color: Colors.amber),
        ),
      );

      currentIndex = end;
    }

    if (currentIndex < end) {
      spans.add(
        TextSpan(
          text: text.substring(currentIndex, end),
          style: const TextStyle(color: Colors.white),
        ),
      );
    }

    return RichText(
      text: TextSpan(
        children: spans,
      ),
    );
  }
}
