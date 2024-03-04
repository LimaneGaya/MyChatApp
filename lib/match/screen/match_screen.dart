import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mychatapp/match/provider/match_provider.dart';
import 'package:mychatapp/services/pocketbase.dart';
import 'package:locale_emoji/locale_emoji.dart' as le;

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

//TODO: Move All the logic to provider (changing sceen reset index)
  @override
  Widget build(BuildContext context) {
    final matches = ref.watch(matchProvider.select((v) => v.matches));
    final index = ref.watch(matchProvider.select((v) => v.index));
    if (matches.isEmpty || index >= matches.length) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          clipBehavior: Clip.antiAlias,
          height: MediaQuery.of(context).size.height / 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Image.network(matches[index].avatar, fit: BoxFit.contain),
        ),
        Text(
          "${matches[index].name} ${matches[index].age} "
          "${le.getFlagEmoji(countryCode: matches[index].countryCode)}",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Expanded(
          child: ref.watch(userImagesProvider(matches[index].id)).when(
                data: (data) {
                  final listImages = data.data['images'] as List;
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: listImages.length,
                    itemBuilder: (context, index) {
                      final String url = PB.getFileUrl(
                          data.id,
                          data.collectionId,
                          data.collectionName,
                          data.data['images'][index]);
                      return Image.network(
                        url,
                        fit: BoxFit.contain,
                      );
                    },
                  );
                },
                error: (err, stack) {
                  debugPrint(err.toString());
                  return const SizedBox(height: 100);
                },
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: ref.read(matchProvider).dislike,
              icon: const Icon(Icons.close),
              label: const Text('Dislike'),
              iconAlignment: IconAlignment.end,
            ),
            ElevatedButton.icon(
              onPressed: ref.read(matchProvider).like,
              icon: const Icon(Icons.check),
              label: const Text('Like  '),
            ),
          ],
        ),
      ],
    );
  }
}
