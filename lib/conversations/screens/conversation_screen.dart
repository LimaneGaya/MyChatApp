import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mychatapp/conversations/providers/conversation_provider.dart';
import 'package:mychatapp/services/pocketbase.dart';

class ConversationsScreen extends StatelessWidget {
  const ConversationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Consumer(
              builder: (context, ref, child) {
                final conversations = ref.watch(conversationStateProvider);
                return ListView.builder(
                  itemCount: conversations.length,
                  itemBuilder: (context, index) {
                    final con = conversations[index];
                    return ListTile(
                      tileColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      onTap: () {
                        ref
                            .read(conversationStateProvider.notifier)
                            .goToConversation(context, con.id);
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
                                  ref
                                      .read(conversationStateProvider.notifier)
                                      .deleteConversation(con.id);
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
                          final names = con.participantData.map(
                            (e) {
                              return e.username;
                            },
                          ).join(', ');
                          return Row(
                            children: [
                              Text(names),
                              const Spacer(),
                              ...con.participantData.map((e) {
                                final image = PB.getFileUrl(
                                  e.id,
                                  e.collectionId,
                                  e.collectionName,
                                  e.avatar,
                                );
                                return CircleAvatar(
                                  backgroundImage:
                                      CachedNetworkImageProvider(image),
                                );
                              }),
                            ],
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
