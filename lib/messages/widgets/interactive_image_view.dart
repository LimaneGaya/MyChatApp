import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class InteractImageViewer extends StatelessWidget {
  final String url;
  const InteractImageViewer(this.url, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: InteractiveViewer(
            clipBehavior: Clip.none,
            child: Hero(
              tag: url,
              child: CachedNetworkImage(
                imageUrl: url,
              ),
            )),
      ),
    );
  }
}
