import 'package:diplomski/theme/custom_theme.dart';
import 'package:diplomski/views/notes_view.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikacija za unos beleski',
      home: const NotesView(),
      theme: CustomTheme.dark(),
    ),
  );
}
