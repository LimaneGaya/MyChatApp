import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_smart_reply/google_mlkit_smart_reply.dart' as ml;
import 'package:image_picker/image_picker.dart';
import 'package:mychatapp/models/models.dart';
import 'package:mychatapp/services/pocketbase.dart';

final messagesStateProvider =
    ChangeNotifierProvider.family<MessagesChangeNotifier, String>(
  (ref, id) => MessagesChangeNotifier(id),
);

class MessagesChangeNotifier extends ChangeNotifier {
  final pb = PB.pb;
  final String id;
  bool isDone = false;
  ml.SmartReply? smartReply;
  final bool isAndroid = defaultTargetPlatform == TargetPlatform.android;
  List<Message> messages = [];
  ml.SmartReplySuggestionResult replies = ml.SmartReplySuggestionResult(
      status: ml.SmartReplySuggestionResultStatus.noReply, suggestions: []);

  MessagesChangeNotifier(this.id) {
    getMessages();
    //TODO: Fix same suggestions appearing on all discussions
    if (isAndroid) smartReply = ml.SmartReply();
  }

  Future<void> getMessages() async {
    PB.subscribe(
      'messages',
      (e) {
        final msg = Message.fromMap(e.record!);
        if (e.action == "create") smartMessageReply(msg);
        if (e.action == "delete") messages.removeWhere((m) => m.id == msg.id);
        if (e.action == 'update') {
          final idx = messages.indexWhere((m) => m.id == msg.id);
          messages[idx] = msg;
        }
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    smartReply?.close();
    super.dispose();
  }

  void smartMessageReply(Message ms) async {
    messages.insert(0, ms);
    if (isAndroid) {
      if (ms.sender == pb.authStore.model.id) {
        smartReply!.addMessageToConversationFromLocalUser(
            ms.content, DateTime.now().millisecondsSinceEpoch);
      } else {
        smartReply!.addMessageToConversationFromRemoteUser(
            ms.content, DateTime.now().millisecondsSinceEpoch, ms.sender);
      }
      replies = await smartReply!.suggestReplies();
      notifyListeners();
    }
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
