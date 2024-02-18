import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mychatapp/services/pocketbase.dart';
import 'package:mychatapp/users/providers/user_provider.dart';
import 'package:mychatapp/users/widgets/user_tile.dart';

class UsersScreen extends ConsumerWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(userStateProvider);
    final isDoneFetching = ref.watch(userStateProvider.notifier).isDoneFetching;
    return GridView.builder(
      itemBuilder: (context, index) {
        if (index == users.length) {
          if (isDoneFetching) return null;
          ref
              .read(userStateProvider.notifier)
              .getNextUsers(page: index ~/ PB.fetchCount);
          return const Center(child: CircularProgressIndicator());
        }
        if (index > users.length) return null;
        return UserTile(users[index]);
      },
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 150,
      ),
    );
  }
}
