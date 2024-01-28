import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mychatapp/provider.dart';
import 'package:pocketbase/pocketbase.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late final pb = ref.read(authStateProvider.notifier).pb;
  List<RecordModel> users = [];

  @override
  void initState() {
    super.initState();
    pocketBase();
  }

  void pocketBase() async {
    print(pb.authStore.model.id);
    final result = await pb.collection('users').getList(
          page: 1,
          perPage: 20,
          filter: 'id != "${pb.authStore.model.id}"',
        );
    users = result.items;
    if (mounted) {
      setState(() {});
    }

    pb.collection('users').subscribe("*", (e) {
      if (e.record != null && e.action == 'create') {
        users.insert(0, e.record!);
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
                ref.read(authStateProvider.notifier).logout();
                // final file = await ImagePicker().pickImage(
                //   source: ImageSource.gallery,
                // );
                // final file2 = await file!.readAsBytes();
                // await pb.collection('posts').create(
                //   body: {
                //     'message': 'Hello there',
                //     'sender': 'yb80zoi843a1nkf',
                //     'reseiver': '8yi8b6cn6velm43',
                //   },
                //   files: [
                //     MultipartFile.fromBytes(
                //       'file',
                //       file2,
                //       filename: 'image.jpg',
                //     ),
                //   ],
                // );
              },
              icon: const Icon(Icons.upload))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) => ListTile(
                onTap: () async {
                  await pb.collection('converstion').create(
                    body: {
                      "isTrusted": false,
                      "participants": [
                        pb.authStore.model.id,
                        users[index].id,
                      ]
                    },
                  );
                },
                title: Text(users[index].data['username']),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
