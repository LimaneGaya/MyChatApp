import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_smart_reply/google_mlkit_smart_reply.dart' as ml;
import 'package:mychatapp/models/message.dart';
import 'package:mychatapp/services/pocketbase.dart';

final smartReplyProvider =
    StateNotifierProvider.family<SmartReplyNotifier, List<String>, String>(
        (ref, String id) => SmartReplyNotifier(id));

class SmartReplyNotifier extends StateNotifier<List<String>> {
  final pb = PB.pb;
  final String id;
  final ml.SmartReply smartReply = ml.SmartReply();
  final bool isAndroid = Platform.isAndroid;

  SmartReplyNotifier(this.id) : super([]);

  void smartMessageReply(Message ms) async {
    if (kIsWeb || !isAndroid) return;
    if (ms.sender == pb.authStore.record!.id) {
      smartReply.addMessageToConversationFromLocalUser(
          ms.content, DateTime.now().millisecondsSinceEpoch);
    } else {
      smartReply.addMessageToConversationFromRemoteUser(
          ms.content, DateTime.now().millisecondsSinceEpoch, ms.sender);
    }
    state =
        await smartReply.suggestReplies().then((replie) => replie.suggestions);
  }

  @override
  void dispose() {
    smartReply.close();
    super.dispose();
  }
}
