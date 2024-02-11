import 'package:feedback/feedback.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ConsumerStatefulWidget, ConsumerState;
import 'package:mychatapp/conversations/screens/conversation_screen.dart';
import 'package:mychatapp/provider.dart' show authStateProvider;
import 'package:mychatapp/users/screens/users_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' show MobileAds;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;

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
    startMessagingNotification();
    startFirebaseServices();
  }

  startFirebaseServices() async {
    if (kIsWeb || defaultTargetPlatform == TargetPlatform.android) {
      //Analytics
      FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
      //Remote Config
      final remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(hours: 5)));
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      //Mobile Ads
      MobileAds.instance.initialize();
      //Crashlitics
      FirebaseCrashlytics.instance.recordFlutterFatalError;
    }
  }

  startMessagingNotification() async {
    //Cloud Messaging //TODO: Add tocken saving to backend and autorefresh.
    try {
      await Future.delayed(const Duration(seconds: 5));
      await FirebaseMessaging.instance.requestPermission(provisional: true);
      String? apnsToken = await FirebaseMessaging.instance.getToken(
          vapidKey:
              'BGdFmH81mQRXyROc_64sE-q74R8qkP2dJLNuJlUTIcXCP4u5Wvpoop6_k8nwhzEWv-Xp9gLmmVv8Z1W63rGifIM');
      await Future.delayed(const Duration(seconds: 5));
      apnsToken = await FirebaseMessaging.instance.getToken(
          vapidKey:
              'BGdFmH81mQRXyROc_64sE-q74R8qkP2dJLNuJlUTIcXCP4u5Wvpoop6_k8nwhzEWv-Xp9gLmmVv8Z1W63rGifIM');
      await Future.delayed(const Duration(seconds: 5));
      apnsToken = await FirebaseMessaging.instance.getToken(
          vapidKey:
              'BGdFmH81mQRXyROc_64sE-q74R8qkP2dJLNuJlUTIcXCP4u5Wvpoop6_k8nwhzEWv-Xp9gLmmVv8Z1W63rGifIM');
      if (apnsToken != null) print(apnsToken);
      //save changed token
      // FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
    } catch (e) {
      print(e.toString());
    }
  }

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
              //TODO: Implement Error reporting
              onPressed: () =>
                  BetterFeedback.of(context).show((UserFeedback feedback) {}),
              icon: const Icon(Icons.bug_report)),
          IconButton(
              onPressed: () async {
                ref.read(authStateProvider.notifier).logout();
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
