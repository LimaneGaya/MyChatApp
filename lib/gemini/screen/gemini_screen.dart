import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mychatapp/messages/widgets/message_field.dart';
import 'package:mychatapp/messages/widgets/message_tile.dart';
import 'package:mychatapp/services/admob.dart';
import 'package:mychatapp/services/env.dart';

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
    safetySettings: [
      SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
      SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.high),
      SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high),
      SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.none),
    ],
    generationConfig: GenerationConfig(maxOutputTokens: 200),
    apiKey: Env.ia,
  );

  late final ChatSession chat;

  BannerAd? _bannerAd;
  final bool isAndroid = defaultTargetPlatform == TargetPlatform.android;
  TextEditingController textController = TextEditingController();
  List<GeminiMessage> messages = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    chat = model.startChat(
      safetySettings: [
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
        SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.high),
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high),
        SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.none),
      ],
      generationConfig: GenerationConfig(maxOutputTokens: 200),
    );
    if (isAndroid) {
      _bannerAd = AdMob.initializeAd();
      setState(() => _bannerAd = _bannerAd);
    }
  }

  void sendMessage() async {
    if (textController.text.trim() == "") return;

    setState(() {
      isLoading = true;
    });

    try {
      var response = await chat.sendMessage(
        Content.text(textController.text.trim()),
      );
      final text = response.text;

      if (text == null) {
        debugPrint('No response from API.');
        return;
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        isLoading = false;
      });
    } finally {
      textController.clear();
      setState(() {
        isLoading = false;
      });
    }
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
                    leadingText: me ? null : 'AI',
                    trailingText: me ? 'Me' : null,
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
      ),
    );
  }
}
