import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mychatapp/home_screen.dart';
import 'package:mychatapp/login_screen.dart';
import 'package:mychatapp/provider.dart';

void main() => runApp(const ProviderScope(child: MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.yellow,
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
