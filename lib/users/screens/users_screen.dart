import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mychatapp/users/providers/user_provider.dart';
import 'package:mychatapp/users/widgets/user_tile.dart';

class UsersScreen extends ConsumerWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(userStateProvider);
    return GridView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        // TODO: uncoment when correctly implementing page loading
        // if (index >= users.length) {
        //   ref.read(userStateProvider.notifier).getUsers();
        // }
        return UserTile(users[index]);
      },
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 150,
      ),
    );
  }
}
