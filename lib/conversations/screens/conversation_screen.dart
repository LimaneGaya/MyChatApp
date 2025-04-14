import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mychatapp/conversations/providers/conversation_provider.dart';
import 'package:mychatapp/conversations/widgets/conversation_tile.dart';
import 'package:mychatapp/l10n/app_localizations.dart';

class ConversationsScreen extends ConsumerWidget {
  const ConversationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final conversations = ref.watch(conversationStateProvider);
    return ListView.builder(
      itemCount: conversations.length,
      itemBuilder: (context, index) {
        final con = conversations[index];
        final names = con.participantData.map((e) => e.name).join(', ');
        return InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () => ref
              .read(conversationStateProvider.notifier)
              .goToConversation(context, con.id),
          onLongPress: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                      title: Text(AppLocalizations.of(context)!.delete_conver,
                          style: TextStyle(color: Colors.red[400])),
                      actions: [
                        TextButton(
                            onPressed: () {
                              ref
                                  .read(conversationStateProvider.notifier)
                                  .deleteConversation(con.id);
                              Navigator.pop(context);
                            },
                            child: Text(AppLocalizations.of(context)!.delete))
                      ])),
          child: ConversationTile(names: names, con: con),
        );
      },
    );
  }
}
