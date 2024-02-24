import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mychatapp/messages/widgets/message_field.dart';
import 'package:mychatapp/messages/widgets/message_tile.dart';
import 'package:mychatapp/services/admob.dart';
import 'package:mychatapp/services/env.dart';
import 'package:mychatapp/services/pocketbase_web.dart'
    if (dart.library.io) 'package:mychatapp/services/pocketbase_none_web.dart'
    as pocket;

class GeminiScreen extends StatefulWidget {
  const GeminiScreen({super.key});

  @override
  State<GeminiScreen> createState() => _GeminiScreenState();
}

class GeminiMessage {
  final bool isMe;
  final String message;
  GeminiMessage(this.isMe, this.message);
}

class _GeminiScreenState extends State<GeminiScreen> {
  final GenerativeModel model = GenerativeModel(
      model: 'gemini-pro',
      safetySettings: [],
      apiKey: Env.ia,
      generationConfig: GenerationConfig(maxOutputTokens: 200),
      httpClient: pocket.client);
  late final ChatSession chat;

  BannerAd? _bannerAd;
  final bool isAndroid = defaultTargetPlatform == TargetPlatform.android;
  TextEditingController textController = TextEditingController();
  List<GeminiMessage> messages = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    chat = model.startChat();
    if (isAndroid) {
      _bannerAd = AdMob.initializeAd();
      setState(() => _bannerAd = _bannerAd);
    }
  }

  void sendMessage() async {
    if (textController.text.trim() == "") return;
    final String m = textController.text.trim();
    messages.add(GeminiMessage(true, m));
    setState(() {
      isLoading = true;
      messages = messages;
      textController.text = '';
    });

    final content = Content.text(m.toLowerCase());
    final response = await chat.sendMessage(content);

    setState(() {
      isLoading = false;
      messages.add(GeminiMessage(false, response.text!));
    });
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        centerTitle: true,
        title: const Text(
          'AI',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            if (!kIsWeb && isAndroid && _bannerAd != null)
              AdMob.getAdWidget(_bannerAd!),
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                    isMe: messages[index].isMe,
                    content: messages[index].message,
                    leadingText: messages[index].isMe ? null : 'Me',
                    trailingText: messages[index].isMe ? 'AI' : null,
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
                    Expanded(child: MessageField(textController, sendMessage)),
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
      ),
    );
  }
}
