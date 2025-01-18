import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show Consumer, ConsumerState, ConsumerStatefulWidget;
import 'package:google_mobile_ads/google_mobile_ads.dart' show BannerAd;
import 'package:image_picker/image_picker.dart' show ImagePicker, XFile;
import 'package:mychatapp/messages/provider/messages_provider.dart';
import 'package:mychatapp/messages/widgets/ai_responses.dart';
import 'package:mychatapp/messages/widgets/message_field.dart';
import 'package:mychatapp/messages/widgets/message_tile.dart';
import 'package:mychatapp/services/admob.dart';
import 'package:mychatapp/services/pocketbase.dart';
import 'package:pocketbase/pocketbase.dart' show PocketBase;

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
  void sendMessage() {
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
            AiResponses(widget._conversationID),
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  final msgs = ref
                      .watch(messagesStateProvider(widget._conversationID))
                      .messages;
                  final bool isDoneFetching = ref
                      .watch(messagesStateProvider(widget._conversationID)
                          .notifier)
                      .isDone;
                  return ListView.builder(
                    reverse: true,
                    itemBuilder: (context, index) {
                      if (index == msgs.length) {
                        if (isDoneFetching) return null;
                        ref
                            .read(messagesStateProvider(widget._conversationID)
                                .notifier)
                            .fetchNextPage(index ~/ PB.fetchCount + 1);
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (index > msgs.length) return null;

                      final ms = msgs[index];
                      final isMe = ms.sender == pb.authStore.record!.id;

                      return MessageTile(
                        isMe: isMe,
                        content: ms.content,
                        fileUrl: ms.file,
                        leadingText: isMe ? null : ms.sender[0],
                        trailingText: isMe
                            ? pb.authStore.record!.data['username'][0]
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
                if (!kIsWeb && isAndroid && _bannerAd != null)
                  AdMob.getAdWidget(_bannerAd!),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: pickFile,
                        icon: const Icon(Icons.image, size: 30)),
                    Expanded(child: MessageField(textController, sendMessage)),
                    IconButton(
                        onPressed: sendMessage,
                        icon: const Icon(Icons.send_rounded, size: 30)),
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
