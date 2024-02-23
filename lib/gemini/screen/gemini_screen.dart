import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiScreen extends StatefulWidget {
  const GeminiScreen({super.key});

  @override
  State<GeminiScreen> createState() => _GeminiScreenState();
}

class _GeminiScreenState extends State<GeminiScreen> {
  late final GenerativeModel model;
  @override
  void initState() {
    super.initState();
    final apiKey = Platform.environment['API_KEY'];
    if (apiKey == null) {
      print('No \$API_KEY environment variable');
      return;
    }
    model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
  }

  void setMessage() async {
    final content = [Content.text('Write a story about a magic backpack.')];
    final response = await model.generateContent(content);
    print(response.text);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center());
  }
}
