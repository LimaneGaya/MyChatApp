import 'dart:io' show Platform;
import 'dart:math' show Random;
import 'dart:ui';
import 'package:feedback/feedback.dart' show BetterFeedback, UserFeedback;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ConsumerState, ConsumerStatefulWidget, StateProvider;
import 'package:mychatapp/conversations/screens/conversation_screen.dart';
import 'package:mychatapp/auth/provider/auth_provider.dart'
    show authStateProvider;
import 'package:mychatapp/gemini/screen/gemini_screen.dart';
import 'package:mychatapp/match/screen/match_screen.dart';
import 'package:mychatapp/match/screen/matched_screen.dart';
import 'package:mychatapp/services/firebase_messaging.dart';
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

//TODO:fix gemini not working with maxtoken
class _HomeScreenState extends ConsumerState<HomeScreen> {
  int index = 0;
  final PageController pageCont = PageController(initialPage: 0);
  @override
  void initState() {
    super.initState();
    if (kIsWeb || Platform.isAndroid) ref.read(firebaseMessagingProvider);
    startFirebaseServices();
  }

  @override
  void dispose() {
    pageCont.dispose();
    super.dispose();
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
    final useRail = MediaQuery.of(context).size.aspectRatio > 1;
    final isTransparent = [0, 1].contains(index);
    return Scaffold(
      backgroundColor: color,
      extendBodyBehindAppBar: isTransparent,
      appBar: useRail
          ? null
          : AppBar(
              backgroundColor: isTransparent ? color.withOpacity(0.7) : color,
              flexibleSpace: isTransparent
                  ? ClipRect(
                      child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(color: Colors.transparent)))
                  : null,
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
              actions: [settings],
            ),
      body: useRail
          ? Row(
              children: [
                NavigationRail(
                  labelType: NavigationRailLabelType.all,
                  backgroundColor: color,
                  selectedIndex: index,
                  onDestinationSelected: (value) => setState(() {
                    index = value;
                    pageCont.animateToPage(value,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease);
                  }),
                  leading: RotatedBox(
                    quarterTurns: 3,
                    child: Text(
                      'Chatly',
                      style: GoogleFonts.tangerine(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                          color: Colors.purple,
                        ),
                      ),
                    ),
                  ),
                  trailing: settings,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.person_outline),
                      selectedIcon: Icon(Icons.person),
                      label: Text('People'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.message_outlined),
                      selectedIcon: Icon(Icons.message),
                      label: Text('Chats'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person_search_outlined),
                      selectedIcon: Icon(Icons.person_search),
                      label: Text('Match'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite_outline),
                      selectedIcon: Icon(Icons.favorite),
                      label: Text('Likes'),
                    ),
                    NavigationRailDestination(
                      icon: Text('AI',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.normal)),
                      selectedIcon: Text('AI',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      label: Text('Advices'),
                    ),
                  ],
                ),
                const VerticalDivider(width: 2),
                Expanded(
                  child: PageView(
                    controller: pageCont,
                    onPageChanged: (value) => setState(() => index = value),
                    children: const [
                      UsersScreen(),
                      ConversationsScreen(),
                      MatchScreen(),
                      MatchedScreen(),
                      GeminiScreen(),
                    ],
                  ),
                )
              ],
            )
          : PageView(
              controller: pageCont,
              onPageChanged: (value) => setState(() => index = value),
              children: const [
                UsersScreen(),
                ConversationsScreen(),
                MatchScreen(),
                MatchedScreen(),
                GeminiScreen(),
              ],
            ),
      bottomNavigationBar: useRail
          ? null
          : NavigationBar(
              backgroundColor: color,
              selectedIndex: index,
              onDestinationSelected: (value) => setState(() {
                index = value;
                pageCont.animateToPage(value,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease);
              }),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: 'People',
                ),
                NavigationDestination(
                  icon: Icon(Icons.message_outlined),
                  selectedIcon: Icon(Icons.message),
                  label: 'Chats',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_search_outlined),
                  selectedIcon: Icon(Icons.person_search),
                  label: 'Match',
                ),
                NavigationDestination(
                  icon: Icon(Icons.favorite_outline),
                  selectedIcon: Icon(Icons.favorite),
                  label: 'Likes',
                ),
                NavigationDestination(
                  icon: Text('AI',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal)),
                  selectedIcon: Text('AI',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  label: 'Advices',
                ),
              ],
            ),
    );
  }

  late final settings = PopupMenuButton(
    icon: const Icon(Icons.settings),
    itemBuilder: (context) => [
      PopupMenuItem(
        onTap: setRandomColor,
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
  );
}
