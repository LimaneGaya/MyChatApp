import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mychatapp/consts/consts.dart';
import 'package:mychatapp/messages/provider/messages_provider.dart';
import 'package:mychatapp/models/models.dart';

class ConversationTile extends ConsumerStatefulWidget {
  const ConversationTile({
    super.key,
    required this.names,
    required this.con,
  });

  final String names;
  final Conversation con;

  @override
  ConsumerState<ConversationTile> createState() => _ConversationTileState();
}

class _ConversationTileState extends ConsumerState<ConversationTile> {
  @override
  initState() {
    super.initState();
    ref.read(messagesStateProvider(widget.con.id));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(15)),
      height: 60,
      child: Row(
        children: [
          Text(widget.names,
              style: TextStyle(
                fontSize: 20,
                shadows: getShadows(context),
              )),
          const Spacer(),
          ...widget.con.participantData.map(
            (e) {
              final image = e.avatar;
              return CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(image),
              );
            },
          ),
        ],
      ),
    );
  }
}
