import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mychatapp/messages/provider/smart_replies_provider.dart';

class AiResponses extends ConsumerWidget {
  final String id;
  const AiResponses(this.id, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = (!kIsWeb && Platform.isAndroid)
        ? ref.watch(smartReplyProvider(id))
        : [];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: messages
          .map((e) => Text(e, style: const TextStyle(fontSize: 10)))
          .toList(),
    );
  }
}
