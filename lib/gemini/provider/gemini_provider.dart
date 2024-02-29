import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:mychatapp/services/env.dart';

final geminiChatProvider = StateNotifierProvider<GeminiNotifier, bool>((ref) {
  return GeminiNotifier();
});

class GeminiNotifier extends StateNotifier<bool> {
  final GenerativeModel model = GenerativeModel(
    model: 'gemini-pro',
    safetySettings: [
      SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
      SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.high),
      SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high),
      SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.none),
    ],
    apiKey: Env.ia,
  );

  late final ChatSession chat;

  GeminiNotifier() : super(true) {
    chat = model.startChat(
      safetySettings: [
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
        SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.high),
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high),
        SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.none),
      ],
    );
    state = false;
  }
  Future<void> sendMessage(String message) async {
    if (message == "") return;
    state = true;
    try {
      var response = await chat.sendMessage(
        Content.text(message),
      );
      final text = response.text;

      if (text == null) {
        debugPrint('No response from API.');
        return;
      } else {
        state = false;
      }
    } catch (e) {
      debugPrint(e.toString());
      state = false;
    } finally {
      state = false;
    }
  }
}

class GeminiMessage {
  final bool isMe;
  final String message;
  GeminiMessage(this.isMe, this.message);
}
