import 'package:feedback/feedback.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' show MobileAds;
import 'package:mychatapp/firebase_options.dart';
import 'package:mychatapp/home_screen.dart';
import 'package:mychatapp/login_screen.dart';
import 'package:mychatapp/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (defaultTargetPlatform == TargetPlatform.android) {
    MobileAds.instance.initialize();
  }
  FirebaseAnalytics.instance;
  FirebaseCrashlytics.instance.recordFlutterFatalError;
  await FirebaseMessaging.instance.requestPermission(provisional: true);
  final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
  if (apnsToken != null) print(apnsToken);
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
          return ref.watch(authStateProvider.notifier).checkIfLogedIn()
              ? const HomeScreen()
              : const LoginScreen();
        },
        error: (error, stackTrace) => Text(error.toString()),
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())));
  }
}
