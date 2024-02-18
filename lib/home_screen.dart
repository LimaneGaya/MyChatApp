import 'dart:io' show Platform;
import 'dart:math';

import 'package:feedback/feedback.dart' show BetterFeedback, UserFeedback;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ConsumerState, ConsumerStatefulWidget, StateProvider;
import 'package:mychatapp/conversations/screens/conversation_screen.dart';
import 'package:mychatapp/provider.dart' show authStateProvider;
import 'package:mychatapp/services/pocketbase.dart';
import 'package:mychatapp/users/screens/users_screen.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:firebase_crashlytics/firebase_crashlytics.dart'
    show FirebaseCrashlytics;
import 'package:firebase_remote_config/firebase_remote_config.dart'
    show FirebaseRemoteConfig, RemoteConfigSettings;
import 'package:google_mobile_ads/google_mobile_ads.dart' show MobileAds;
import 'package:flutter/foundation.dart' show kIsWeb;

final themeColor = StateProvider<Color>((ref) => Colors.pink);

final brightness = StateProvider<Brightness>((ref) => Brightness.dark);

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int index = 0;
  @override
  void initState() {
    super.initState();
    if (kIsWeb || Platform.isAndroid) startMessagingNotification();
    startFirebaseServices();
  }

  startFirebaseServices() async {
    if (kIsWeb || Platform.isAndroid) {
      //Remote Config
      final remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(hours: 5)));
    }
    if (!kIsWeb && Platform.isAndroid) {
      //Mobile Ads
      MobileAds.instance.initialize();
      //Crashlitics
      FirebaseCrashlytics.instance.recordFlutterFatalError;
    }
  }

  startMessagingNotification() async {
    final timetowait = Future.delayed(const Duration(seconds: 5));
    await timetowait;
    await FirebaseMessaging.instance.requestPermission(provisional: true);
    //Cloud Messaging //TODO: Add token saving to backend and autorefresh.
    String? apnsToken;
    try {
      apnsToken = await getNotificationToken();
      apnsToken = await getNotificationToken();
      apnsToken = await getNotificationToken();
      await timetowait;
    } catch (e) {
      try {
        apnsToken = await getNotificationToken();
        await timetowait;
      } catch (e) {
        try {
          apnsToken = await getNotificationToken();
          await timetowait;
        } catch (e) {
          debugPrint(e.toString());
        }
      }
      debugPrint(apnsToken);
    }
    //save changed token
    // FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
  }

  Future<String?> getNotificationToken() => FirebaseMessaging.instance.getToken(
      vapidKey: 'BGdFmH81mQRXyROc_64sE-q74R8qkP2dJLNuJlUTIcXCP'
          '4u5Wvpoop6_k8nwhzEWv-Xp9gLmmVv8Z1W63rGifIM');

  void setRandomColor() {
    ref.read(themeColor.notifier).state = Color.fromARGB(255,
        Random().nextInt(255), Random().nextInt(255), Random().nextInt(255));
  }

  void changeTheme() {
    final br = ref.read(brightness);
    ref.read(brightness.notifier).state =
        br == Brightness.dark ? Brightness.light : Brightness.dark;
  }

  void showFeedBack() {
    BetterFeedback.of(context).show((UserFeedback feedback) {
      if (feedback.text != '') {
        PB.uploadReport(feedback.text, feedback.screenshot);
      } else {
        showDialog(
            context: context,
            builder: (context) =>
                const AlertDialog(content: Text('Please enter feedback')));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSecondary;
    return Scaffold(
      backgroundColor: color,
      appBar: AppBar(
        backgroundColor: color,
        centerTitle: true,
        title: Text(
          'Chatly',
          style: GoogleFonts.tangerine(
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 40,
              color: Colors.purple,
            ),
          ),
        ),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.settings),
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: () => setRandomColor,
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.color_lens_rounded),
                    SizedBox(width: 10),
                    Text('Change color'),
                  ],
                ),
              ),
              PopupMenuItem(
                  onTap: changeTheme,
                  child: ref.watch(brightness) == Brightness.dark
                      ? const Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.nightlight),
                            SizedBox(width: 10),
                            Text('Dark mode'),
                          ],
                        )
                      : const Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.sunny),
                            SizedBox(width: 10),
                            Text('Light mode'),
                          ],
                        )),
              PopupMenuItem(
                onTap: showFeedBack,
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.bug_report),
                    SizedBox(width: 10),
                    Text('Report a bug / Request a feature'),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: () async {
                  ref.read(authStateProvider.notifier).logout(context);
                },
                child: const Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 10),
                    Text('Logout'),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
      body: IndexedStack(
        index: index,
        children: const [
          UsersScreen(),
          ConversationsScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: color,
        onTap: (value) => setState(() => index = value),
        items: [
          BottomNavigationBarItem(
            icon: Icon(index == 0 ? Icons.person : Icons.person_outline),
            label: 'People',
          ),
          BottomNavigationBarItem(
            icon: Icon(index == 1 ? Icons.message : Icons.message_outlined),
            label: 'Chats',
          ),
        ],
      ),
    );
  }
}
