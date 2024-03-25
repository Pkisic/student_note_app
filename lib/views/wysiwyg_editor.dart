import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';

class WysiwygEditor extends StatefulWidget {
  const WysiwygEditor({Key? key}) : super(key: key);

  @override
  State<WysiwygEditor> createState() => _WysiwygEditorState();
}

HtmlEditorController controller = HtmlEditorController();

class _WysiwygEditorState extends State<WysiwygEditor> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Wysiwyg editor'),
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: 'Editor',
                ),
                Tab(
                  text: 'Preview',
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              SafeArea(
                child: HtmlEditor(
                  controller: controller,
                  htmlEditorOptions: const HtmlEditorOptions(),
                ),
              ),
              const Center(
                child: Text('Preview'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
