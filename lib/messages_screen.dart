import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ConsumerStatefulWidget, ConsumerState;
import 'package:google_mobile_ads/google_mobile_ads.dart'
    show BannerAd, AdWidget;
import 'package:mychatapp/messages/widgets/message_tile.dart';
import 'package:mychatapp/provider.dart' show authStateProvider;
import 'package:mychatapp/services/admob.dart';
import 'package:pocketbase/pocketbase.dart' show PocketBase, RecordModel;

class MessengerScreen extends ConsumerStatefulWidget {
  final String _conversationID;
  const MessengerScreen(this._conversationID, {super.key});

  @override
  ConsumerState<MessengerScreen> createState() => _MessengerScreenState();
}

class _MessengerScreenState extends ConsumerState<MessengerScreen> {
  List<RecordModel> messages = [];
  late PocketBase pb;
  String googleAdAppId = 'ca-app-pub-3152914819070890~2075174973';
  BannerAd? _bannerAd;
  final bool isAndroid = defaultTargetPlatform == TargetPlatform.android;
  @override
  void initState() {
    super.initState();
    pb = ref.read(authStateProvider.notifier).pb;
    getMessages();
    if (isAndroid) {
      _bannerAd = AdMob.initializeAd();
      setState(() {});
    }
  }

  Future<void> getMessages() async {
    final mes = await pb.collection('messages').getList(
          page: 1,
          perPage: 50,
          filter: 'conversation = "${widget._conversationID}"',
          sort: '-created',
        );
    if (mounted) setState(() => messages = mes.items);
    setSubscription();
  }

  void setSubscription() {
    pb.collection('messages').subscribe(
      '*',
      (e) {
        messages.insert(0, e.record!);
        debugPrint(e.record!.data.toString());
        if (mounted) setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final isMe =
                    messages[index].data['sender'] == pb.authStore.model.id;

                return MessageTile(
                  isMe: isMe,
                  content: messages[index].data['content'],
                  fileUrl: messages[index].data['file'].length != 0
                      ? pb.files
                          .getUrl(messages[index],
                              messages[index].data['file'][0].toString())
                          .toString()
                      : null,
                  leadingText: isMe ? null : messages[index].data['sender'][0],
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
              if (isAndroid && _bannerAd != null) AdMob.getAdWidget(_bannerAd!),
              TextField(
                autofocus: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: const BorderSide(width: 5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                onSubmitted: (value) {
                  final pb = ref.read(authStateProvider.notifier).pb;
                  pb.collection('messages').create(
                    body: {
                      "conversation": widget._conversationID,
                      "sender": pb.authStore.model.id,
                      "content": value,
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
