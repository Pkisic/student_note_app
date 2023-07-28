import 'dart:async';

import 'package:diplomski/models/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

class NotesService {
  Database? _db;

  List<Note> _notes = [];

  //Singleton
  static final NotesService _shared = NotesService._sharedInstance();
  NotesService._sharedInstance() {
    _notesStreamController = StreamController<List<Note>>.broadcast(
      onListen: () {
        _notesStreamController.sink.add(_notes);
      },
    );
  }
  factory NotesService() => _shared;
  //end singleton
  late final StreamController<List<Note>> _notesStreamController;

  Stream<List<Note>> get allNotes => _notesStreamController.stream;

  Future<Iterable<Note>> getAllNotes() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final notes = await db.query(
      notesTable,
    );

    return notes.map((noteRow) => Note.fromRow(noteRow));
  }

  Future<Note> getNote({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final notes = await db.query(
      notesTable,
      limit: 1,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (notes.isEmpty) {
      throw Exception('Could not find a note');
    } else {
      final note = Note.fromRow(notes.first);
      _notes.removeWhere((note) => note.id == id);
      _notes.add(note);
      _notesStreamController.add(_notes);
      return note;
    }
  }

  Future<Note> createNote({
    required String title,
    required String text,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final noteId = await db.insert(notesTable, {
      titleColumn: title,
      textColumn: text,
      categoryColumn: 1,
    });

    final note = Note(
      id: noteId,
      title: title,
      text: text,
    );

    _notes.add(note);
    _notesStreamController.add(_notes);

    return note;
  }

  Future<Note> updateNote({
    required Note note,
    required String text,
    required String title,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    await getNote(id: note.id);

    final updatesCount = await db.update(
      notesTable,
      {
        textColumn: text,
        titleColumn: title,
      },
      where: 'id = ?',
      whereArgs: [note.id],
    );
    if (updatesCount == 0) {
      throw Exception('Could not update');
    } else {
      final updatedNote = await getNote(id: note.id);
      _notes.removeWhere((note) => note.id == updatedNote.id);
      _notes.add(updatedNote);
      _notesStreamController.add(_notes);
      return updatedNote;
    }
  }

  Future<void> deleteNote({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      notesTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (deletedCount == 0) {
      throw Exception('Could not delete note!');
    } else {
      _notes.removeWhere((note) => note.id == id);
      _notesStreamController.add(_notes);
    }
  }

  Future<void> _cacheNotes() async {
    final allNotes = await getAllNotes();
    _notes = allNotes.toList();
    _notesStreamController.add(_notes);
  }

  //DATABASE
  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null || !db.isOpen) {
      throw Exception('No database available');
    } else {
      return db;
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw Exception('No database available');
    } else {
      await db.close();
      _db = null;
    }
  }

  Future<void> _ensureDbIsOpen() async {
    try {
      await open();
    } on Exception {
      //empty
    }
  }

  Future<void> open() async {
    if (_db != null) {
      throw Exception('Database already opened!');
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;
      //create tables
      await db.execute(createCategoryTable);
      await db.execute(createNotesTable);
      //notes
      await _cacheNotes();
    } on MissingPlatformDirectoryException {
      throw Exception('Unable to get documents directory');
    }
  }

  Future<void> deleteDB() async {
    if (_db == null) {
      throw Exception('Database already null');
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      await deleteDatabase(dbPath);
    } on Exception {
      //nada
    }
  }
}

const dbName = 'notes.db';
const notesTable = "notes";
const categoriesTable = "categories";

const idColumn = "id";
const titleColumn = "title";
const textColumn = "text";
const categoryColumn = "category_id";

const createNotesTable = '''
CREATE TABLE IF NOT EXISTS "notes" (
  "id"	INTEGER NOT NULL,
	"text"	TEXT NOT NULL,
	"title"	TEXT NOT NULL,
	"category_id"	INTEGER,
	PRIMARY KEY("id" AUTOINCREMENT)
);
''';
const createCategoryTable = '''
CREATE TABLE IF NOT EXISTS "categories" (
	"id"	INTEGER NOT NULL,
	"color"	INTEGER NOT NULL,
	"name"	TEXT NOT NULL,
	"description"	TEXT,
	PRIMARY KEY("id" AUTOINCREMENT)
);
''';
