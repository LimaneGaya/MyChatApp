import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mychatapp/provider.dart';
import 'package:pocketbase/pocketbase.dart';

class MessengerScreen extends ConsumerStatefulWidget {
  final String _conversationID;
  const MessengerScreen(this._conversationID, {super.key});

  @override
  ConsumerState<MessengerScreen> createState() => _MessengerScreenState();
}

class _MessengerScreenState extends ConsumerState<MessengerScreen> {
  List<RecordModel> messages = [];
  late PocketBase pb;

  @override
  void initState() {
    super.initState();
    pb = ref.read(authStateProvider.notifier).pb;
    getMessages();
  }

  Future<void> getMessages() async {
    final mes = await pb.collection('messages').getList(
          page: 1,
          perPage: 50,
          filter: 'conversation = "${widget._conversationID}"',
          sort: '-created',
        );
    if (mounted) setState(() => messages = mes.items);
    setSubscription();
  }

  void setSubscription() {
    pb.collection('messages').subscribe(
      '*',
      (e) {
        messages.insert(0, e.record!);
        print(e.record!.data);
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        reverse: true,
        itemCount: messages.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(messages[index].data['content']),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: TextField(
          onSubmitted: (value) {
            final pb = ref.read(authStateProvider.notifier).pb;
            pb.collection('messages').create(
              body: {
                "conversation": widget._conversationID,
                "sender": pb.authStore.model.id,
                "content": value,
              },
            );
          },
        ),
      ),
    );
  }
}
