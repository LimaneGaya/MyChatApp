import 'dart:io' show Platform;

import 'package:feedback/feedback.dart' show BetterFeedback, UserFeedback;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ConsumerStatefulWidget, ConsumerState;
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
    //Cloud Messaging //TODO: Add tocken saving to backend and autorefresh.
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          IconButton(
              onPressed: () =>
                  BetterFeedback.of(context).show((UserFeedback feedback) {
                    if (feedback.text != '') {
                      PB.uploadReport(feedback.text, feedback.screenshot);
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => const AlertDialog(
                            content: Text('Please enter feedback')),
                      );
                    }
                  }),
              icon: const Icon(Icons.bug_report)),
          IconButton(
              onPressed: () async {
                ref.read(authStateProvider.notifier).logout(context);
              },
              icon: const Icon(Icons.logout)),
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
