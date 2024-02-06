import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ConsumerStatefulWidget, ConsumerState;
import 'package:mychatapp/messages_screen.dart';
import 'package:mychatapp/models/models.dart';
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

  int index = 0;
  RecordModel? link;

  @override
  void initState() {
    super.initState();
    pocketBase();
  }

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
                child: GridView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final UserModel user =
                        UserModel.fromMap(users[index].toJson());
                    return GridTile(
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15)),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: () => checkConExistAndGoTo(index),
                          child: Stack(
                            children: [
                              Image.network(
                                PB.getUrl(
                                  RecordModel(
                                    id: user.id,
                                    collectionId: user.collectionId,
                                    collectionName: user.collectionName,
                                  ),
                                  user.avatar,
                                ),
                                width: double.infinity,
                                fit: BoxFit.cover,
                                filterQuality: FilterQuality.medium,
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  height: 35,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.7),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(user.username),
                                      Text(
                                        '${user.gender} ${user.age}',
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 150,
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
                  itemBuilder: (context, index) {
                    final con = Conversation.fromMap(
                      conversations[index].toJson(),
                    );
                    return ListTile(
                      onTap: () {
                        goToConversation(con.id);
                      },
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(
                              'Delete conversation?',
                              style: TextStyle(color: Colors.red[400]),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  deleteConversation(con.id);
                                  Navigator.pop(context);
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                      },
                      title: Builder(
                        builder: (context) {
                          final names = con.participantData.map((e) {
                            return e.username;
                          }).join(', ');
                          return Row(
                            children: [
                              Text(names),
                              const Spacer(),
                              ...con.participantData.map((e) {
                                final image = PB.getUrl(
                                  RecordModel(
                                    id: e.id,
                                    collectionId: e.collectionId,
                                    collectionName: e.collectionName,
                                  ),
                                  e.avatar,
                                );
                                return CircleAvatar(
                                    backgroundImage: NetworkImage(image));
                              }),
                            ],
                          );
                        },
                      ),
                    );
                  },
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

  void pocketBase() async {
    users = await PB.getUsers();
    if (mounted) setState(() {});
    conversations = await PB.getConversation();
    if (mounted) setState(() {});
  }

  void checkConExistAndGoTo(int index) async {
    final int idx = conversations.indexWhere(
      (e) => e.data['participants'].contains(
        users[index].id,
      ),
    );
    if (idx == -1) {
      final con = await pb.collection('converstion').create(
        body: {
          "isTrusted": false,
          "participants": [
            pb.authStore.model.id,
            users[index].id,
          ]
        },
      );
      if (mounted) goToConversation(con.id);
    } else {
      final String id = conversations[idx].id;
      goToConversation(id);
    }
  }

  void goToConversation(String id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MessengerScreen(id),
      ),
    );
  }

  void deleteConversation(String id) {
    PB.deleteConvertation(id);
  }
}
