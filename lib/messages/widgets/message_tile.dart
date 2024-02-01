import 'package:flutter/material.dart';

class MessageTile extends StatelessWidget {
  final bool isMe;
  final String? trailingText;
  final String? leadingText;
  final String content;
  final String? fileUrl;
  const MessageTile({
    super.key,
    required this.isMe,
    this.leadingText,
    this.trailingText,
    required this.content,
    this.fileUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: trailingText != null ? Text(trailingText!) : null,
      leading: leadingText == null ? null : Text(leadingText!),
      tileColor: isMe
          ? Theme.of(context).colorScheme.onTertiary
          : Theme.of(context).colorScheme.onSecondary,
      title: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Text(content),
      ),
      subtitle: fileUrl != null
          ? Container(
              margin: const EdgeInsets.all(10),
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Image.network(
                fileUrl!,
                height: 250,
                filterQuality: FilterQuality.low,
                fit: BoxFit.fitWidth,
              ),
            )
          : null,
    );
  }
}
