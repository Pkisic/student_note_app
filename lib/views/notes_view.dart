import 'package:diplomski/eums/menu_action.dart';
import 'package:diplomski/models/note.dart';
import 'package:diplomski/services/notes_service.dart';
import 'package:diplomski/views/create_update_note_view.dart';
import 'package:diplomski/views/notes_list_view.dart';
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
                    onPressed: () {},
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
                  case ConnectionState.active:
                    if (snapshot.hasData) {
                      final allNotes = snapshot.data as List<Note>;
                      return NotesListView(notes: allNotes);
                    } else {
                      return const SliverToBoxAdapter(
                        child: CircularProgressIndicator(),
                      );
                    }
                  default:
                    return const SliverToBoxAdapter(
                      child: CircularProgressIndicator(),
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
        ));
  }
}
