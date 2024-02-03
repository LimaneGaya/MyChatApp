import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ConsumerStatefulWidget, ConsumerState;
import 'package:mychatapp/messages_screen.dart';
import 'package:mychatapp/provider.dart' show authStateProvider;
import 'package:mychatapp/services/pocketbase.dart';
import 'package:pocketbase/pocketbase.dart' show RecordModel;

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final pb = PB.pb;
  List<RecordModel> users = [];
  List<RecordModel> conversations = [];

  @override
  void initState() {
    super.initState();
    pocketBase();
  }

  void pocketBase() async {
    users = await PB.getUsers();
    if (mounted) setState(() {});
    conversations = await PB.getConversation();
    if (mounted) setState(() {});
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
                    title: FutureBuilder(
                      //TODO: fix this
                      future: PB.getUsersWithIds(
                        (conversations[index].data['participants']
                            as List<String>),
                      ),
                      builder: (context, snapshot) {
                        return Text(snapshot.data!
                            .map((e) => e.data['username'])
                            .toString());
                      },
                    ),
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
