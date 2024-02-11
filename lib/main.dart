import 'package:feedback/feedback.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' show MobileAds;
import 'package:mychatapp/firebase_options.dart';
import 'package:mychatapp/home_screen.dart';
import 'package:mychatapp/login_screen.dart';
import 'package:mychatapp/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb || defaultTargetPlatform == TargetPlatform.android) {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    //Analytics
    FirebaseAnalytics.instance;
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

  runApp(const ProviderScope(child: BetterFeedback(child: MyApp())));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue.shade900,
        brightness: Brightness.dark,
      )),
      home: const InitialScreen(),
    );
  }
}

class InitialScreen extends ConsumerWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(sharedPrefProvider).when(
        data: (data) {
          return ref.watch(authCheckifLoginIsValid).when(
              data: (data) => data ? const HomeScreen() : const LoginScreen(),
              error: (error, stackTrace) =>
                  Scaffold(body: Center(child: Text(error.toString()))),
              loading: () => const Scaffold(
                  body: Center(child: CircularProgressIndicator())));
        },
        error: (error, stackTrace) => Text(error.toString()),
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())));
  }
}
