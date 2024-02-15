import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mychatapp/conversations/providers/conversation_provider.dart';
import 'package:mychatapp/models/models.dart';
import 'package:mychatapp/services/pocketbase.dart';
import 'package:mychatapp/users/providers/user_provider.dart';

class UserProfile extends StatelessWidget {
  final UserModel user;
  const UserProfile(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              backgroundColor: Colors.blue,
              expandedHeight: 200,
              floating: false,
              title: Text(user.name),
              flexibleSpace: Stack(
                children: [
                  Hero(
                    tag: user.id,
                    child: CachedNetworkImage(
                      imageUrl: user.avatar,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.medium,
                    ),
                  ),
                  Container(
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.black, Colors.transparent],
                              begin: Alignment.bottomCenter,
                              end: Alignment.center))),
                ],
              ),

              // Stack(children: [
              //   Align(
              //     alignment: Alignment.center,
              //     child: CircleAvatar(
              //       radius: 50,
              //       foregroundImage:
              //           NetworkImage('https://picsum.photos/id/237/200/300'),
              //     ),
              //   )
              // ]),
              bottom: const TabBar(
                tabs: [Tab(child: Text('Info')), Tab(child: Text('Photos'))],
              ),
            )
          ],
          body: Consumer(
            builder: (context, ref, child) {
              return ref.watch(userDetailsProvider(user.id)).when(
                data: (data) {
                  return TabBarView(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Last Seen: ${user.lastSeen.toLocal()}'),
                          Text(data.data['bio'] as String),
                        ],
                      ),
                      GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3),
                        itemCount: data.data['images'].length,
                        itemBuilder: (context, index) {
                          return GridTile(
                              child: CachedNetworkImage(
                                  imageUrl: PB.getFileUrl(
                                      data.id,
                                      data.collectionId,
                                      data.collectionName,
                                      data.data['images'][index])));
                        },
                      ),
                    ],
                  );
                },
                error: (error, stackTrace) {
                  return TabBarView(children: [
                    Center(child: Text(error.toString())),
                    Center(child: Text(error.toString())),
                  ]);
                },
                loading: () {
                  return const TabBarView(children: [
                    Center(child: CircularProgressIndicator()),
                    Center(child: CircularProgressIndicator()),
                  ]);
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Consumer(
            builder: (context, ref, child) => IconButton(
                onPressed: () => ref
                    .read(conversationStateProvider.notifier)
                    .checkConExistAndGoTo(context, user.id),
                icon: const Icon(Icons.message)),
          )
        ],
      ),
    );
  }
}
