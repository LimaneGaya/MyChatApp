import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show Consumer, ConsumerState, ConsumerStatefulWidget;
import 'package:google_mobile_ads/google_mobile_ads.dart' show BannerAd;
import 'package:image_picker/image_picker.dart' show ImagePicker, XFile;
import 'package:mychatapp/messages/provider/messages_provider.dart';
import 'package:mychatapp/messages/widgets/message_field.dart';
import 'package:mychatapp/messages/widgets/message_tile.dart';
import 'package:mychatapp/services/admob.dart';
import 'package:mychatapp/services/pocketbase.dart';
import 'package:pocketbase/pocketbase.dart' show PocketBase;
import 'package:google_mlkit_smart_reply/google_mlkit_smart_reply.dart';

class MessengerScreen extends ConsumerStatefulWidget {
  final String _conversationID;
  const MessengerScreen(this._conversationID, {super.key});

  @override
  ConsumerState<MessengerScreen> createState() => _MessengerScreenState();
}

class _MessengerScreenState extends ConsumerState<MessengerScreen> {
  PocketBase pb = PB.pb;
  BannerAd? _bannerAd;
  final bool isAndroid = defaultTargetPlatform == TargetPlatform.android;
  List<XFile> files = [];
  TextEditingController textController = TextEditingController();
  final smartReply = SmartReply();

  @override
  void initState() {
    super.initState();
    if (isAndroid) {
      _bannerAd = AdMob.initializeAd();
      setState(() => _bannerAd = _bannerAd);
    }
  }

  @override
  void dispose() {
    textController.dispose();
    smartReply.close();
    super.dispose();
  }

  Future<void> pickFile() async {
    final picker = ImagePicker();
    final f = await picker.pickMultiImage(
      imageQuality: 40,
      maxHeight: 1024,
      maxWidth: 1024,
    );
    files = f.length >= 4 ? f.sublist(0, 4) : f;
  }

  bool isme = true;
  void sendMessage() async {
    //#Block Smart Reply
    if (!kIsWeb && Platform.isAndroid) {
      isme
          ? smartReply.addMessageToConversationFromLocalUser(
              textController.text.trim(), DateTime.now().millisecondsSinceEpoch)
          : smartReply.addMessageToConversationFromRemoteUser(
              textController.text.trim(),
              DateTime.now().millisecondsSinceEpoch,
              'user');
      isme = !isme;
      final res = await smartReply.suggestReplies();
      if (mounted) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: res.suggestions.map((e) => Text(e)).toList())));
      }
      //#Block Smart Reply
    }
    //Send Message
    ref
        .read(messagesStateProvider(widget._conversationID))
        .sendMessage(textController.text.trim(), files);
    setState(() => textController.text = '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  final msgs = ref
                      .watch(messagesStateProvider(widget._conversationID))
                      .messages;
                  return ListView.builder(
                    reverse: true,
                    itemCount: msgs.length,
                    itemBuilder: (context, index) {
                      final ms = msgs[index];
                      final isMe = ms.sender == pb.authStore.model.id;

                      return MessageTile(
                        isMe: isMe,
                        content: ms.content,
                        fileUrl: ms.file,
                        leadingText: isMe ? null : ms.sender[0],
                        trailingText: isMe
                            ? pb.authStore.model.data['username'][0]
                            : null,
                      );
                    },
                  );
                },
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (isAndroid && _bannerAd != null)
                  AdMob.getAdWidget(_bannerAd!),
                Row(
                  children: [
                    IconButton(
                        onPressed: pickFile, icon: const Icon(Icons.image)),
                    Expanded(child: MessageField(textController, sendMessage)),
                    IconButton(
                        onPressed: sendMessage,
                        icon: const Icon(Icons.send_rounded)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
