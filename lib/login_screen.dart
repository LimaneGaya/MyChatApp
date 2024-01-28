import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mychatapp/home_screen.dart';
import 'package:mychatapp/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool canSeePassword = false;
  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Chatty',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: userNameController,
              maxLength: 25,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 4,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  gapPadding: 10,
                ),
                hintText: 'User Name',
                icon: const Icon(Icons.person_3),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              obscureText: !canSeePassword,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 4,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  gapPadding: 10,
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      canSeePassword = !canSeePassword;
                    });
                  },
                  icon: Icon(canSeePassword
                      ? Icons.close_rounded
                      : Icons.remove_red_eye),
                ),
                hintText: 'Password',
                icon: const Icon(Icons.password),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  return ElevatedButton(
                    onPressed: () async {
                      final isLoggedin =
                          await ref.read(authStateProvider.notifier).login(
                                userNameController.text,
                                passwordController.text,
                              );

                      if (isLoggedin && mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                          (route) => false,
                        );
                      }
                    },
                    child: const Text('LogIn'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
