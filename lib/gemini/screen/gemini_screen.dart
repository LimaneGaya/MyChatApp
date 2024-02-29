import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mychatapp/gemini/provider/gemini_provider.dart';
import 'package:mychatapp/messages/widgets/message_field.dart';
import 'package:mychatapp/messages/widgets/message_tile.dart';
import 'package:mychatapp/services/admob.dart';

class GeminiScreen extends ConsumerStatefulWidget {
  const GeminiScreen({super.key});

  @override
  ConsumerState<GeminiScreen> createState() => _GeminiScreenState();
}

class _GeminiScreenState extends ConsumerState<GeminiScreen> {
  BannerAd? _bannerAd;
  final bool isAndroid = defaultTargetPlatform == TargetPlatform.android;
  TextEditingController textController = TextEditingController();
  final ScrollController scrollCont = ScrollController();

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
    scrollCont.dispose();
    super.dispose();
  }

  sendMessage() async {
    await ref
        .read(geminiChatProvider.notifier)
        .sendMessage(textController.text);
    textController.clear();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => scrollCont.animateTo(
        scrollCont.position.maxScrollExtent,
        duration: const Duration(seconds: 10),
        curve: Curves.linear,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chat = ref.watch(geminiChatProvider.notifier).chat;
    final isLoading = ref.watch(geminiChatProvider);

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          if (!kIsWeb && isAndroid && _bannerAd != null)
            AdMob.getAdWidget(_bannerAd!),
          Expanded(
            child: ListView.builder(
              controller: scrollCont,
              itemCount: chat.history.length,
              itemBuilder: (context, index) {
                final mess = chat.history.elementAt(index);
                final bool me = mess.role == 'user';
                return MessageTile(
                  isMe: me,
                  content: mess.parts
                      .whereType<TextPart>()
                      .map<String>((e) => e.text)
                      .join(''),
                  leadingText: null,
                  trailingText: null,
                );
              },
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                      child: MessageField(
                    textController,
                    sendMessage,
                    autofocus: false,
                  )),
                  isLoading
                      ? IconButton(
                          onPressed: () {},
                          icon: const CircularProgressIndicator())
                      : IconButton(
                          onPressed: sendMessage,
                          icon: const Icon(Icons.send_rounded, size: 30)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
