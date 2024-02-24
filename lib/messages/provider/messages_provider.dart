import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mychatapp/messages/provider/smart_replies_provider.dart';
import 'package:mychatapp/models/models.dart';
import 'package:mychatapp/services/pocketbase.dart';

final messagesStateProvider =
    ChangeNotifierProvider.family<MessagesChangeNotifier, String>(
  (ref, id) => MessagesChangeNotifier(
      id: id,
      smartReply: (!kIsWeb && Platform.isAndroid)
          ? ref.watch(smartReplyProvider(id).notifier)
          : null),
);

class MessagesChangeNotifier extends ChangeNotifier {
  final pb = PB.pb;
  final SmartReplyNotifier? smartReply;
  final String id;
  bool isDone = false;
  List<Message> messages = [];
  MessagesChangeNotifier({required this.id, this.smartReply}) {
    getMessages();
  }

  Future<void> getMessages() async {
    PB.subscribe(
      'messages',
      (e) {
        final msg = Message.fromMap(e.record!);
        if (e.action == "create") {
          messages.insert(0, msg);
          smartReply?.smartMessageReply(msg);
        }
        if (e.action == "delete") messages.removeWhere((m) => m.id == msg.id);
        if (e.action == 'update') {
          final idx = messages.indexWhere((m) => m.id == msg.id);
          messages[idx] = msg;
        }
        notifyListeners();
      },
    );
  }

  Future<void> fetchNextPage(int page) async {
    if (isDone) return;
    final msgs = await PB.getMessages(id, page: page);
    if (msgs.length < PB.fetchCount) isDone = true;
    messages = messages + msgs.map((e) => Message.fromMap(e)).toList();
    notifyListeners();
  }

  void sendMessage(String text, List<XFile> files) {
    PB.createMessage(
      conversationId: id,
      content: text,
      files: files,
    );
  }
}
