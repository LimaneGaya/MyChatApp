import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mychatapp/messages/widgets/interactive_image_view.dart';

class MessageTile extends StatelessWidget {
  final bool isMe;
  final String? trailingText;
  final String? leadingText;
  final String content;
  final List<String> fileUrl;
  const MessageTile({
    super.key,
    required this.isMe,
    this.leadingText,
    this.trailingText,
    required this.content,
    this.fileUrl = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (leadingText != null)
            CircleAvatar(radius: 18, child: Text(leadingText!)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width / 1.4,
                  child: Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      child: Text(content),
                    ),
                  ),
                ),
                if (fileUrl.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  InteractImageViewer(fileUrl[0]))),
                      child: Hero(
                        tag: fileUrl[0],
                        child: CachedNetworkImage(
                          imageUrl: fileUrl[0],
                          height: 250,
                          filterQuality: FilterQuality.low,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (trailingText != null)
            CircleAvatar(radius: 18, child: Text(trailingText!)),
        ],
      ),
    );
  }
}
