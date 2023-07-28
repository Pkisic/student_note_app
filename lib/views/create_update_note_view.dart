import 'package:flutter/material.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({Key? key}) : super(key: key);

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
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
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  style: Theme.of(context).textTheme.headlineMedium,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: 'Title',
                    hintStyle: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  expands: true,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'Your note ..',
                    hintStyle: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  decoration: InputDecoration(
                      hintText: 'Category',
                      hintStyle: Theme.of(context).textTheme.bodySmall),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
