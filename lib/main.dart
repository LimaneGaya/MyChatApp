import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:http/http.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.yellow,
        brightness: Brightness.dark,
      )),
      home: const App(),
    );
  }
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final pb = PocketBase('http://127.0.0.1:8090');
  List<RecordModel> messages = [];
  @override
  void initState() {
    super.initState();
    pocketBase();
  }

  void pocketBase() async {
    await pb
        .collection('users')
        .authWithPassword('limanegaya@gmail.com', '123456789');
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
      if (e.record != null && e.action == 'create') {
        messages.insert(0, e.record!);
      }
      if (mounted) {
        setState(() {});
      }
    });
  }

  RecordModel? link;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                final file = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                );
                final file2 = await file!.readAsBytes();
                await pb.collection('posts').create(
                  body: {
                    'message': 'Hello there',
                    'sender': 'yb80zoi843a1nkf',
                    'reseiver': '8yi8b6cn6velm43',
                  },
                  files: [
                    MultipartFile.fromBytes(
                      'file',
                      file2,
                      filename: 'image.jpg',
                    ),
                  ],
                );
              },
              icon: const Icon(Icons.upload))
        ],
      ),
      body: Column(
        children: [
          if (link != null)
            Image.network(pb.files
                .getUrl(
                  link!,
                  link!.data['file'],
                  thumb: '50x50',
                )
                .toString()),
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) => ListTile(
                onTap: () {
                  if (messages[index].data['file'] != null) {
                    link = messages[index];
                    setState(() {});
                  }
                },
                title: Text(messages[index].data['message']),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
