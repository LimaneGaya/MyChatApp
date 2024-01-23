import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.yellow,
        brightness: Brightness.dark,
      )),
      home: App(),
    );
  }
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  List<RecordModel> messages = [];
  @override
  void initState() {
    super.initState();
    pocketBase();
  }

  void pocketBase() async {
    final pb = PocketBase('http://127.0.0.1:8090');
    final userData = await pb
        .collection('users')
        .authWithPassword('limanegaya@gmail.com', '123456789');
    print('User is: ${userData.record}');
    final result = await pb.collection('posts').getList(
          page: 1,
          perPage: 20,
          sort: '-created',
          expand: 'resiever',
        );
    messages = result.items;
    if (mounted) {
      setState(() {});
    }

    pb.collection('posts').subscribe("*", (e) {
      print('Update: ${e.action}');
      print('Update: ${e.record}');
      if (e.record != null && e.action == 'create') messages.add(e.record!);
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(messages[index].data['message']),
        ),
      ),
    );
  }
}
