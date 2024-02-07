import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mychatapp/messages_screen.dart';
import 'package:mychatapp/models/models.dart';
import 'package:mychatapp/services/pocketbase.dart';

final conversationStateProvider =
    StateNotifierProvider<ConversationNotifier, List<Conversation>>(
  (ref) => ConversationNotifier(),
);

class ConversationNotifier extends StateNotifier<List<Conversation>> {
  final pb = PB.pb;
  ConversationNotifier() : super([]) {
    getConversations();
  }

  void getConversations() async {
    final convs = await PB.getConversation();
    state = convs.map((e) => Conversation.fromMap(e.toJson())).toList();
  }

  void checkConExistAndGoTo(BuildContext context, String userId) async {
    final int idx = state.indexWhere(
      (e) => e.participantIds.contains(userId),
    );
    if (idx == -1) {
      final con = await pb.collection('converstion').create(
        body: {
          "isTrusted": false,
          "participants": [pb.authStore.model.id, userId]
        },
      );
      if (context.mounted) goToConversation(context, con.id);
    } else {
      final String id = state[idx].id;
      goToConversation(context, id);
    }
  }

  void goToConversation(BuildContext context, String id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MessengerScreen(id),
      ),
    );
  }

  void deleteConversation(String id) async {
    await PB.deleteConvertation(id);
    state.remove(state.firstWhere((element) => element.id == id));
    state = state;
  }
}
