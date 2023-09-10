import 'package:diplomski/services/notes_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class CreateCategoryView extends StatefulWidget {
  const CreateCategoryView({Key? key}) : super(key: key);

  @override
  State<CreateCategoryView> createState() => _CreateCategoryViewState();
}

class _CreateCategoryViewState extends State<CreateCategoryView> {
  late final NotesService _notesService;
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  Color pickerColor = Color(0xff44a49);
  Color currentColor = Color(0xff44a49);

  void changeColor(Color color) {
    setState(() {
      pickerColor = color;
    });
  }

  @override
  void initState() {
    _notesService = NotesService();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<bool> _saveCategoryIfTextNotEmpty() async {
    final name = _nameController.text;
    final desc = _descriptionController.text;
    if (name.isNotEmpty) {
      await _notesService.createCategory(
        name: name,
        description: desc,
        color: currentColor,
      );
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Icon(Icons.settings),
            IconButton(
              tooltip: 'save the new note to database and go back.',
              onPressed: () async {
                final create = _saveCategoryIfTextNotEmpty();
                if (await create) {
                  Navigator.of(context).pop();
                }
              },
              icon: Icon(Icons.plus_one),
            )
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Create a category',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(
                  height: 50.0,
                ),
                TextField(
                  decoration:
                      const InputDecoration(hintText: 'Category name..'),
                  controller: _nameController,
                ),
                const SizedBox(
                  height: 50.0,
                ),
                TextField(
                  decoration: const InputDecoration(hintText: 'Description..'),
                  controller: _descriptionController,
                ),
                const SizedBox(
                  height: 50.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Pick a color!'),
                              content: SingleChildScrollView(
                                child: ColorPicker(
                                  pickerColor: pickerColor,
                                  onColorChanged: changeColor,
                                  pickerAreaHeightPercent: 0.8,
                                ),
                              ),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: const Text('Got it'),
                                  onPressed: () {
                                    setState(() => currentColor = pickerColor);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text('Pick a color'),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: currentColor,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
