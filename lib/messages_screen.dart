import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ConsumerStatefulWidget, ConsumerState;
import 'package:google_mobile_ads/google_mobile_ads.dart' show BannerAd;
import 'package:image_picker/image_picker.dart';
import 'package:mychatapp/messages/widgets/message_tile.dart';
import 'package:mychatapp/models/message.dart';
import 'package:mychatapp/services/admob.dart';
import 'package:mychatapp/services/pocketbase.dart';
import 'package:pocketbase/pocketbase.dart' show PocketBase, RecordModel;

class MessengerScreen extends ConsumerStatefulWidget {
  final String _conversationID;
  const MessengerScreen(this._conversationID, {super.key});

  @override
  ConsumerState<MessengerScreen> createState() => _MessengerScreenState();
}

class _MessengerScreenState extends ConsumerState<MessengerScreen> {
  List<RecordModel> messages = [];
  PocketBase pb = PB.pb;
  BannerAd? _bannerAd;
  final bool isAndroid = defaultTargetPlatform == TargetPlatform.android;
  List<XFile> files = [];

  @override
  void initState() {
    super.initState();
    getMessages();
    if (isAndroid) {
      _bannerAd = AdMob.initializeAd();
      setState(() => _bannerAd = _bannerAd);
    }
  }

  Future<void> getMessages() async {
    final mes = await PB.getMessages(widget._conversationID);
    if (mounted) setState(() => messages = mes);
    PB.subscribe('messages', (e) {
      messages.insert(0, e.record!);
      debugPrint('realtime message: ${e.record!.data.toString()}');
      if (mounted) setState(() {});
    });
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

  void sendMessage(String value) {
    PB.createMessage(
      conversationId: widget._conversationID,
      content: value,
      files: files,
    );
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
              child: ListView.builder(
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final ms = Message.fromMap(messages[index]);
                  final isMe = ms.sender == pb.authStore.model.id;

                  return MessageTile(
                    isMe: isMe,
                    content: ms.content,
                    fileUrl: ms.file,
                    leadingText: isMe ? null : ms.sender[0],
                    trailingText:
                        isMe ? pb.authStore.model.data['username'][0] : null,
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
                      onPressed: pickFile,
                      icon: const Icon(Icons.image),
                    ),
                    Expanded(
                      child: TextField(
                        autofocus: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: const BorderSide(width: 5),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        onSubmitted: sendMessage,
                      ),
                    ),
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
