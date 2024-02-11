import 'package:feedback/feedback.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mychatapp/firebase_options.dart';
import 'package:mychatapp/home_screen.dart';
import 'package:mychatapp/login_screen.dart';
import 'package:mychatapp/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb || defaultTargetPlatform == TargetPlatform.android) {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
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
