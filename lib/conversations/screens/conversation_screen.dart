import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mychatapp/conversations/providers/conversation_provider.dart';
import 'package:mychatapp/services/pocketbase.dart';

class ConversationsScreen extends ConsumerWidget {
  const ConversationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversations = ref.watch(conversationStateProvider);
    return ListView.builder(
      itemCount: conversations.length,
      itemBuilder: (context, index) {
        final con = conversations[index];
        final names = con.participantData.map((e) => e.username).join(', ');
        return InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () => ref
              .read(conversationStateProvider.notifier)
              .goToConversation(context, con.id),
          onLongPress: () => showDialog(
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
                            child: const Text('Delete'))
                      ])),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(15)),
            height: 60,
            child: Row(
              children: [
                Text(names,
                    style: const TextStyle(
                        fontSize: 20, shadows: [Shadow(blurRadius: 5)])),
                const Spacer(),
                ...con.participantData.map(
                  (e) {
                    final image = PB.getFileUrl(
                      e.id,
                      e.collectionId,
                      e.collectionName,
                      e.avatar,
                    );
                    return CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(image),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
