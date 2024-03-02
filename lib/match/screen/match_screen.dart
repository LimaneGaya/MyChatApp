import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mychatapp/match/provider/match_provider.dart';

class MatchScreen extends ConsumerStatefulWidget {
  const MatchScreen({super.key});

  @override
  ConsumerState<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends ConsumerState<MatchScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(matchProvider).getMatches();
  }

  @override
  Widget build(BuildContext context) {
    final matches = ref.watch(matchProvider.select((v) => v.matches));
    final index = ref.watch(matchProvider.select((v) => v.index));
    if (matches.isEmpty || index >= matches.length) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      children: [
        Image.network(
          matches[index].avatar,
          fit: BoxFit.cover,
          height: MediaQuery.of(context).size.height / 1.7,
          width: double.infinity,
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton.filled(
                onPressed: ref.read(matchProvider).dislike,
                icon: const Icon(Icons.close)),
            IconButton.filled(
                onPressed: ref.read(matchProvider).like,
                icon: const Icon(Icons.check))
          ],
        )
      ],
    );
  }
}
