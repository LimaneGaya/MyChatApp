import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mychatapp/match/provider/match_provider.dart';
import 'package:locale_emoji/locale_emoji.dart' as le;
import 'package:mychatapp/profiles/user_profile_screen.dart';

class MatchedScreen extends ConsumerWidget {
  const MatchedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(matchedListProvide).when(
          data: (data) {
            if (data.isEmpty) {
              return const Center(child: Text('No matches yet'));
            }
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserProfile(data[index]))),
                  title: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40.0, vertical: 10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Theme.of(context).colorScheme.onPrimary),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                              data[index].avatar,
                            ),
                            minRadius: 40),
                        Text(data[index].name),
                        Text(data[index].age.toString()),
                        if (data[index].countryCode != '')
                          Text(
                            le.getFlagEmoji(
                                    countryCode: data[index].countryCode) ??
                                '???',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          error: (error, stackTrace) {
            debugPrint(error.toString());
            return const Center(child: Text('Please refresh the page'));
          },
          loading: () => const Center(child: CircularProgressIndicator()),
        );
  }
}
