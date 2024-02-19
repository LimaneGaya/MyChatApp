import 'package:cached_network_image/cached_network_image.dart'
    show CachedNetworkImage;
import 'package:country/country.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Consumer;
import 'package:mychatapp/consts/consts.dart';
import 'package:mychatapp/models/models.dart';
import 'package:mychatapp/profiles/user_profile_screen.dart';

class UserTile extends StatelessWidget {
  final UserModel user;
  const UserTile(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Container(
        margin: const EdgeInsets.all(5),
        width: 100,
        height: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [BoxShadow(blurRadius: 5)]),
        clipBehavior: Clip.antiAlias,
        child: Consumer(
          builder: (context, ref, child) {
            return InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UserProfile(user))),
              child: Stack(
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
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 36,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .background
                            .withOpacity(0.7),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            user.username,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              shadows: getShadows(context),
                            ),
                          ),
                          Text(
                            '${user.gender} ${user.age}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (user.countryCode != '')
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6.0,
                          vertical: 2,
                        ),
                        child: Text(
                          Countries.values
                              .firstWhere(
                                (element) => element.alpha2 == user.countryCode,
                              )
                              .flagEmoji,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
