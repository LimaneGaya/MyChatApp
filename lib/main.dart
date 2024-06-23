import 'package:feedback/feedback.dart' show BetterFeedback;
import 'package:firebase_analytics/firebase_analytics.dart'
    show FirebaseAnalytics, FirebaseAnalyticsObserver;
import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mychatapp/auth/screens/auth_screen.dart';
import 'package:mychatapp/firebase_options.dart';
import 'package:mychatapp/home_screen.dart';
import 'package:mychatapp/auth/provider/auth_provider.dart';
import 'package:mychatapp/onboarding_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      title: 'MyChatApp',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar'),
        Locale('fr'),
        Locale('en'),
      ],
      locale: ref.watch(localProvider),
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
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
          if (data.getBool('onboarding') == null) {
            return OnboadringScreen();
          }
          return ref.watch(authCheckifLoginIsValid).when(
              data: (data) => data ? const HomeScreen() : const AuthScreen(),
              error: (error, stackTrace) =>
                  Scaffold(body: Center(child: Text(error.toString()))),
              loading: () => const Scaffold(
                  body: Center(child: CircularProgressIndicator())));
        },
        error: (error, stackTrace) => const Text(
            'There was an error please check connection or try again later'),
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())));
  }
}
