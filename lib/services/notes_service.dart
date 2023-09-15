import 'dart:async';
import 'package:diplomski/models/note.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

import '../models/category.dart';

class NotesService {
  Database? _db;

  List<Note> _notes = [];
  List<Category> _categories = [];

  //Singleton
  static final NotesService _shared = NotesService._sharedInstance();
  NotesService._sharedInstance() {
    _notesStreamController = StreamController<List<Note>>.broadcast(
      onListen: () {
        _notesStreamController.sink.add(_notes);
      },
    );
    _categoriesStreamController = StreamController<List<Category>>.broadcast(
      onListen: () {
        _categoriesStreamController.sink.add(_categories);
      },
    );
  }
  factory NotesService() => _shared;
  //end singleton
  late final StreamController<List<Note>> _notesStreamController;
  late final StreamController<List<Category>> _categoriesStreamController;

  Stream<List<Note>> get allNotes => _notesStreamController.stream;
  Stream<List<Category>> get allCategories =>
      _categoriesStreamController.stream;

  Future<List<Note>> getTheNotes(String query) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final searchResults = await db.rawQuery("$searchQuery'*$query*'");
    return searchResults.map((noteRow) => Note.fromRow(noteRow)).toList();
  }

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

  Future<Category> getCategory({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final categories = await db.query(
      categoriesTable,
      limit: 1,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (categories.isEmpty) {
      return Future<Category>.value(
        Category(
          id: -1,
          color: Colors.black,
          description: 'Uncategorized',
          name: 'Uncategorized',
        ),
      );
    } else {
      final category = Category.fromRow(categories.first);
      _categories.removeWhere((category) => category.id == id);
      _categories.add(category);
      _categoriesStreamController.add(_categories);
      return category;
    }
  }

  Future<Note> createNote({
    required String title,
    required String text,
    required Category? category,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final noteId = await db.insert(notesTable, {
      titleColumn: title,
      textColumn: text,
      categoryColumn: category?.id ?? -1,
    });

    final note = Note(
      id: noteId,
      title: title,
      text: text,
      category: category?.id ?? -1,
    );

    _notes.add(note);
    _notesStreamController.add(_notes);

    return note;
  }

  Future<Note> updateNote({
    required Note note,
    required String text,
    required String title,
    required Category? category,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    await getNote(id: note.id);

    final updatesCount = await db.update(
      notesTable,
      {
        textColumn: text,
        titleColumn: title,
        categoryColumn: category?.id ?? -1,
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

  //CATEGORY

  Future<List<Category>> getAllCategories() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final categories = await db.query(
      categoriesTable,
    );

    return categories
        .map((categoryRow) => Category.fromRow(categoryRow))
        .toList();
  }

  Future<Category> createCategory({
    required String name,
    required String? description,
    required Color color,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final categoryId = await db.insert(categoriesTable, {
      nameColumn: name,
      descriptionColumn: description,
      colorColumn: color.value,
    });

    final category = Category(
      id: categoryId,
      name: name,
      description: description,
      color: color,
    );

    _categories.add(category);
    _categoriesStreamController.add(_categories);

    return category;
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
      //add default category
      try {
        await db.execute(createDefaultCategoy);
      } on Exception {}
      //add search modifiers
      try {
        await db.execute(createSearchTable);
        await db.execute(insertInitialSearchData);
        await db.execute(createInsertTrigger);
        await db.execute(createUpdateTrigger);
        await db.execute(createDeleteTrigger);
      } on Exception {
        print('Exception search tables');
      }
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
const searchTable = "term_table";

const idColumn = "id";
const titleColumn = "title";
const textColumn = "text";

const categoryColumn = "category_id";
const colorColumn = "color";
const nameColumn = "name";
const descriptionColumn = "description";

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

const createDefaultCategoy = '''
INSERT INTO categories (id, name, description, color)
VALUES(-1,'Uncategorized','Uncategorized',4278190080);
''';

const createSearchTable = '''
CREATE VIRTUAL TABLE term_table
USING FTS4(id,text,title);
''';

const insertInitialSearchData = '''
INSERT INTO term_table(id, text, title)
SELECT
  id,
  text,
  title
FROM notes;
''';

const createInsertTrigger = '''
CREATE TRIGGER insert_term_table
  after insert on notes
begin
  insert into term_table(id, text, title)
  values(new.id, new.text, new.title);
end;
''';

const createUpdateTrigger = '''
CREATE TRIGGER update_term_table
  after update on notes
begin
  update term_table
  set text = new.text,
      title = new.title
  where id = new.id;
end;
''';

const createDeleteTrigger = '''
CREATE TRIGGER delete_term_table
  after delete on notes
begin
  DELETE FROM term_table
  WHERE id = OLD.id;
end;
''';

const searchQuery = '''
SELECT *
FROM term_table tt
INNER JOIN notes n on tt.id = n.id
WHERE term_table MATCH 
''';
