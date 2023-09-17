import 'package:diplomski/eums/menu_action.dart';
import 'package:diplomski/models/note.dart';
import 'package:diplomski/services/notes_service.dart';
import 'package:diplomski/views/create_update_note_view.dart';
import 'package:diplomski/views/notes_list_view.dart';
import 'package:diplomski/views/notes_search_result_view.dart';
import 'package:flutter/material.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final NotesService _notesService;

  @override
  void initState() {
    _notesService = NotesService();
    _notesService.open();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverAppBar(
            floating: false,
            pinned: true,
            expandedHeight: 200,
            backgroundColor: Colors.black,
            flexibleSpace: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                const SizedBox(
                  width: 200,
                  child: FlexibleSpaceBar(
                    title: Text("Notes"),
                    expandedTitleScale: 2,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: CustomSearchDelegate(),
                    );
                  },
                  color: Colors.white,
                ),
                PopupMenuButton(
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem<MenuAction>(
                        value: MenuAction.about,
                        child: const Text('About'),
                        onTap: () => _notesService.deleteDB(),
                      ),
                      const PopupMenuItem(
                        value: MenuAction.settings,
                        child: Text('Settings'),
                      ),
                    ];
                  },
                )
              ],
            ),
          ),
          StreamBuilder(
            stream: _notesService.allNotes,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const SliverToBoxAdapter(
                    child: LinearProgressIndicator(),
                  );
                case ConnectionState.active:
                  if (snapshot.hasData) {
                    final allNotes = snapshot.data as List<Note>;
                    return NotesListView(
                      notes: allNotes,
                      onDeleteNote: (Note note) async {
                        await _notesService.deleteNote(id: note.id);
                      },
                      onTap: (Note note) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const CreateUpdateNoteView(),
                            settings: RouteSettings(arguments: note),
                          ),
                        );
                      },
                    );
                  } else {
                    return const SliverToBoxAdapter(
                      child: LinearProgressIndicator(),
                    );
                  }
                default:
                  return const SliverToBoxAdapter(
                    child: LinearProgressIndicator(),
                  );
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CreateUpdateNoteView(),
            ),
          );
        },
        backgroundColor: Colors.orange[900],
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  final NotesService _notesService = NotesService();

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text('no data');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: _notesService.getTheNotes(query),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const LinearProgressIndicator();
          case ConnectionState.active:
            if (snapshot.hasData) {
              final allNotes = snapshot.data as List<Note>;
              return NotesSearchResultView(
                notes: allNotes,
                query: query,
              );
            } else {
              return const LinearProgressIndicator();
            }
          case ConnectionState.done:
            if (snapshot.hasData) {
              final allNotes = snapshot.data as List<Note>;
              return NotesSearchResultView(
                notes: allNotes,
                query: query,
              );
            } else {
              return const Text('No results');
            }
          default:
            return const LinearProgressIndicator();
        }
      },
    );
  }
}
