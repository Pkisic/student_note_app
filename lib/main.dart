import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: MyHomePage(title: 'My notes'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          SliverAppBar(
            title: const Text('Notes'),
            floating: true,
            flexibleSpace: const FlexibleSpaceBar(
              stretchModes: <StretchMode>[StretchMode.fadeTitle],
            ),
            expandedHeight: 200,
            stretch: true,
            pinned: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {},
              )
            ],
            backgroundColor: Colors.blueGrey,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Card(
                child: ListTile(
                  title: Text('Item #$index'),
                  subtitle: Text('Subtitle $index'),
                  isThreeLine: true,
                  tileColor: Colors.white,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {},
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(300)),
                ),
              ),
              childCount: 40,
            ),
          ),
        ],
      ),
    );
  }
}
