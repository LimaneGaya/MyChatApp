import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ConsumerStatefulWidget, ConsumerState;
import 'package:google_mobile_ads/google_mobile_ads.dart'
    show BannerAd, AdRequest, AdSize, BannerAdListener, AdWidget;
import 'package:mychatapp/provider.dart' show authStateProvider;
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
  bool _isLoaded = false;
  final bool isAndroid = defaultTargetPlatform == TargetPlatform.android;
  @override
  void initState() {
    super.initState();
    pb = ref.read(authStateProvider.notifier).pb;
    getMessages();
    if (isAndroid) initializeAd();
  }

  void initializeAd() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          setState(() {
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          ad.dispose();
        },
      ),
    )..load();
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

                return ListTile(
                  trailing: isMe
                      ? Text(pb.authStore.model.data['username'][0])
                      : null,
                  leading:
                      isMe ? null : Text(messages[index].data['sender'][0]),
                  tileColor: isMe
                      ? Theme.of(context).colorScheme.onTertiary
                      : Theme.of(context).colorScheme.onSecondary,
                  title: Align(
                    alignment:
                        isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Text(messages[index].data['content']),
                  ),
                  subtitle: messages[index].data['file'].length != 0
                      ? Container(
                          margin: const EdgeInsets.all(10),
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Image.network(
                            pb.files
                                .getUrl(messages[index],
                                    messages[index].data['file'][0].toString())
                                .toString(),
                            height: 250,
                            filterQuality: FilterQuality.low,
                            fit: BoxFit.fitWidth,
                          ),
                        )
                      : null,
                );
              },
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_isLoaded && isAndroid)
                SizedBox(
                  width: _bannerAd!.size.width.toDouble(),
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                ),
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
