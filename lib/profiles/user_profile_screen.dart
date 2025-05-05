import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mychatapp/consts/consts.dart';
import 'package:mychatapp/conversations/providers/conversation_provider.dart';
import 'package:mychatapp/messages/widgets/interactive_image_view.dart';
import 'package:mychatapp/models/models.dart';
import 'package:mychatapp/services/pocketbase.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:mychatapp/users/providers/user_provider.dart';
import 'package:mychatapp/l10n/app_localizations.dart';

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
              iconTheme:
                  IconThemeData(shadows: getShadows(context), opacity: 1),
              backgroundColor: Colors.blue,
              expandedHeight: 200,
              floating: false,
              title: Text(user.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    shadows: getShadows(context),
                  )),
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
              bottom: TabBar(
                tabs: [Tab(child: Text(AppLocalizations.of(context)!.info)), 
                Tab(child: Text(AppLocalizations.of(context)!.photos)),],
              ),
            )
          ],
          body: Consumer(
            builder: (context, ref, child) {
              const spacing = EdgeInsets.all(8);
              final decoration = BoxDecoration(
                  color: Theme.of(context).colorScheme.onTertiary,
                  border: Border.all(
                      color: Theme.of(context).colorScheme.tertiary, width: 3),
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
                                  text: AppLocalizations.of(context)!.lastseen,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                  children: [
                                    TextSpan(
                                        text: GetTimeAgo.parse(user.lastSeen.toLocal()),
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
                            child: Text(data.data['bio'] as String),
                          ),
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
                  return  TabBarView(children: [
                    Center(child: Text(AppLocalizations.of(context)!.nothingtoshow)),
                    Center(child: Text(AppLocalizations.of(context)!.nothingtoshow)),
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
