import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mychatapp/auth/provider/auth_provider.dart';
import 'package:mychatapp/auth/screens/auth_screen.dart';

class OnboadringScreen extends StatelessWidget {
  OnboadringScreen({super.key});
  final pageCont = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageCont,
        children: [
          const Center(child: Text('1')),
          const Center(child: Text('2')),
          const Center(child: Text('3')),
          Center(
              child: Consumer(
            builder: (context, ref, child) => ElevatedButton(
                onPressed: () {
                  ref
                      .read(sharedPrefProvider)
                      .value!
                      .setBool('onboarding', false);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AuthScreen()));
                },
                child: const Text('Get Started')),
          )),
        ],
      ),
    );
  }
}
