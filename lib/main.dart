import 'package:feedback/feedback.dart' show BetterFeedback;
import 'package:firebase_analytics/firebase_analytics.dart'
    show FirebaseAnalytics, FirebaseAnalyticsObserver;
import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mychatapp/firebase_options.dart';
import 'package:mychatapp/home_screen.dart';
import 'package:mychatapp/login_screen.dart';
import 'package:mychatapp/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: BetterFeedback(child: MyApp())));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
//Analytics
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'My chat App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
        seedColor: ref.watch(themeColor),
        brightness: ref.watch(brightness),
      )),
      navigatorObservers: [observer],
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
