import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ConsumerStatefulWidget, ConsumerState;
import 'package:mychatapp/messages_screen.dart';
import 'package:mychatapp/provider.dart' show authStateProvider;
import 'package:pocketbase/pocketbase.dart' show RecordModel;

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late final pb = ref.read(authStateProvider.notifier).pb;
  List<RecordModel> users = [];
  List<RecordModel> conversations = [];

  @override
  void initState() {
    super.initState();
    pocketBase();
  }

  void pocketBase() async {
    debugPrint('home initial id: ${pb.authStore.model.id}');
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
    final res = await pb.collection('converstion').getList(
          page: 1,
          perPage: 20,
          filter: 'participants ~ "${pb.authStore.model.id}"',
        );
    conversations = res.items;
    if (mounted) {
      setState(() {});
    }
  }

  int index = 0;
  RecordModel? link;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                ref.read(authStateProvider.notifier).logout();
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: IndexedStack(
        index: index,
        children: [
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) => ListTile(
                    onTap: () async {
                      final con = await pb.collection('converstion').create(
                        body: {
                          "isTrusted": false,
                          "participants": [
                            pb.authStore.model.id,
                            users[index].id,
                          ]
                        },
                      );
                      if (mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MessengerScreen(con.id),
                          ),
                        );
                      }
                    },
                    title: Text(users[index].data['username']),
                  ),
                ),
              ),
            ],
          ),
          //Conversation List
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: conversations.length,
                  itemBuilder: (context, index) => ListTile(
                    onTap: () async {
                      if (mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MessengerScreen(conversations[index].id),
                          ),
                        );
                      }
                    },
                    title: Text(
                        conversations[index].data['participants'].toString()),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) => setState(() => index = value),
        items: [
          BottomNavigationBarItem(
            icon: Icon(index == 0 ? Icons.person : Icons.person_outline),
            label: 'People',
          ),
          BottomNavigationBarItem(
            icon: Icon(index == 1 ? Icons.message : Icons.message_outlined),
            label: 'Chats',
          ),
        ],
      ),
    );
  }
}
