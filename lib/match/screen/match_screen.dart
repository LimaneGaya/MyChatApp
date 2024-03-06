import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mychatapp/match/provider/match_provider.dart';
import 'package:mychatapp/services/pocketbase.dart';
import 'package:locale_emoji/locale_emoji.dart' as le;

class MatchScreen extends ConsumerWidget {
  const MatchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final match = ref.watch(matchProvider);
    if (match == null) {
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
          child:
              CachedNetworkImage(imageUrl: match.avatar, fit: BoxFit.contain),
        ),
        Text(
          "${match.name} ${match.age} "
          "${le.getFlagEmoji(countryCode: match.countryCode)}",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Expanded(
          child: ref.watch(userImagesProvider(match.id)).when(
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
                      return CachedNetworkImage(
                        imageUrl: url,
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
              onPressed: ref.read(matchProvider.notifier).dislike,
              icon: const Icon(Icons.close),
              label: const Text('Dislike'),
              iconAlignment: IconAlignment.end,
            ),
            ElevatedButton.icon(
              onPressed: ref.read(matchProvider.notifier).like,
              icon: const Icon(Icons.check),
              label: const Text('Like  '),
            ),
          ],
        ),
      ],
    );
  }
}
