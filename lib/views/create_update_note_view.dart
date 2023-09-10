import 'package:diplomski/models/category.dart';
import 'package:diplomski/models/note.dart';
import 'package:diplomski/services/notes_service.dart';
import 'package:diplomski/utilities/generics/get_arguments.dart';
import 'package:diplomski/views/create_category_view.dart';
import 'package:flutter/material.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({Key? key}) : super(key: key);

  @override
  State<CreateUpdateNoteView> createState() => CreateUpdateNoteViewState();

  static CreateUpdateNoteViewState of(BuildContext context) =>
      context.findAncestorStateOfType<CreateUpdateNoteViewState>()!;
}

class CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  Note? _note;
  late final NotesService _notesService;
  late final TextEditingController _textController;
  late final TextEditingController _titleController;
  Category? _categoryState;

  @override
  void initState() {
    _notesService = NotesService();
    _textController = TextEditingController();
    _titleController = TextEditingController();
    super.initState();
  }

  setCategory(Note? note) async {
    _note = context.getArgument<Note>();

    if (note == null) return;

    _categoryState = await _notesService
        .getCategory(id: _note?.category ?? -1)
        .then((value) => value);
  }

  void _textControllerListener() async {
    final note = _note;
    if (note == null || note.text == '' || note.text == '') return;
    final text = _textController.text;
    final title = _titleController.text;
    await _notesService.updateNote(
      note: note,
      text: text,
      title: title,
      category: _categoryState,
    );
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  Future<Note> createOrGetExistingNote(BuildContext context) async {
    final widgetNote = context.getArgument<Note>();
    if (widgetNote != null) {
      _note = widgetNote;
      _textController.text = widgetNote.text;
      _titleController.text = widgetNote.title;
      if (_categoryState == null) {
        setCategory(_note);
      }
      return widgetNote;
    }

    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    print('create note');
    final newNote = await _notesService.createNote(
      text: '',
      title: '',
      category: _categoryState ?? Category.none(Colors.black),
    );
    _note = newNote;
    return newNote;
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      _notesService.deleteNote(id: note.id);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textController.text;
    final title = _titleController.text;
    if (note != null && text.isNotEmpty) {
      await _notesService.updateNote(
        note: note,
        text: text,
        title: title,
        category: _categoryState,
      );
    }
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              final snack = SnackBar(
                content: const Text('Saved!'),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {},
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snack);
            },
            icon: const Icon(Icons.check),
          )
        ],
      ),
      body: FutureBuilder(
        future: createOrGetExistingNote(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _setupTextControllerListener();
              return SafeArea(
                top: true,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TitleSlot(titleController: _titleController),
                    TextSlot(textController: _textController),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: FutureBuilder(
                        future: _notesService.getAllCategories(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final categories = snapshot.data as List<Category>;
                            return Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    textStyle:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                  child: Icon(
                                    Icons.color_lens,
                                    color:
                                        _categoryState?.color ?? Colors.white,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0,
                                    ),
                                    child: DropdownButton<Category>(
                                      value: _categoryState,
                                      items: categories
                                          .map<DropdownMenuItem<Category>>(
                                              (Category value) {
                                        return DropdownMenuItem<Category>(
                                          value: value,
                                          child: Text(
                                            value.name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayMedium,
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (Category? newValue) {
                                        setState(() {
                                          _categoryState = newValue;
                                        });
                                      },
                                      alignment: Alignment.center,
                                      isExpanded: true,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const CreateCategoryView(),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.add,
                                  ),
                                )
                              ],
                            );
                          } else {
                            return Text('No categories');
                          }
                        },
                      ),
                    )
                  ],
                ),
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

class TitleSlot extends StatelessWidget {
  const TitleSlot({
    Key? key,
    required TextEditingController titleController,
  })  : _titleController = titleController,
        super(key: key);

  final TextEditingController _titleController;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      fit: FlexFit.tight,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: TextFormField(
          style: Theme.of(context).textTheme.headlineMedium,
          controller: _titleController,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            hintText: 'Title',
            hintStyle: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      ),
    );
  }
}

class TextSlot extends StatelessWidget {
  const TextSlot({
    Key? key,
    required TextEditingController textController,
  })  : _textController = textController,
        super(key: key);

  final TextEditingController _textController;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 2,
      fit: FlexFit.tight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          expands: true,
          maxLines: null,
          controller: _textController,
          decoration: InputDecoration(
            hintText: 'Your note ..',
            hintStyle: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }
}
