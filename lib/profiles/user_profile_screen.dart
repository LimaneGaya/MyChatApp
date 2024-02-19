import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mychatapp/conversations/providers/conversation_provider.dart';
import 'package:mychatapp/messages/widgets/interactive_image_view.dart';
import 'package:mychatapp/models/models.dart';
import 'package:mychatapp/services/pocketbase.dart';
import 'package:mychatapp/users/providers/user_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

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
              iconTheme: const IconThemeData(
                  shadows: [Shadow(blurRadius: 5)], opacity: 1),
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
              const spacing = EdgeInsets.all(8);
              final decoration = BoxDecoration(
                  color: Theme.of(context).colorScheme.onTertiary,
                  borderRadius: BorderRadius.circular(15));
              return ref.watch(userDetailsProvider(user.id)).when(
                data: (data) {
                  return TabBarView(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            margin: spacing,
                            padding: spacing,
                            decoration: decoration,
                            child: RichText(
                              text: TextSpan(
                                  text: 'Last seen: ',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                  children: [
                                    TextSpan(
                                        text: timeago
                                            .format(user.lastSeen.toLocal())
                                            .toString(),
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .tertiary,
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal))
                                  ]),
                            ),
                          ),
                          Container(
                              constraints:
                                  const BoxConstraints.expand(height: 300),
                              margin: spacing,
                              padding: spacing,
                              decoration: decoration,
                              child: Text(data.data['bio'] as String)),
                        ],
                      ),
                      GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3),
                        itemCount: data.data['images'].length,
                        itemBuilder: (context, index) {
                          final String url = PB.getFileUrl(
                              data.id,
                              data.collectionId,
                              data.collectionName,
                              data.data['images'][index]);
                          return GridTile(
                              child: Container(
                                  margin: spacing,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15)),
                                  child: InkWell(
                                      borderRadius: BorderRadius.circular(15),
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                InteractImageViewer(url),
                                          )),
                                      child: Hero(
                                        tag: url,
                                        child: CachedNetworkImage(
                                            imageUrl: url, fit: BoxFit.cover),
                                      ))));
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
