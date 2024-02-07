import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mychatapp/users/providers/user_provider.dart';
import 'package:mychatapp/users/widgets/user_tile.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Consumer(
            builder: (context, ref, child) {
              final users = ref.watch(userStateProvider);
              return GridView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) => UserTile(users[index]),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 150,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
