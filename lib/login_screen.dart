import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show Consumer, WidgetRef;
import 'package:mychatapp/auth/widgets/auth_text_field.dart';
import 'package:mychatapp/home_screen.dart';
import 'package:mychatapp/provider.dart' show authStateProvider;
import 'package:mychatapp/register_screen.dart';

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
            AuthTextField(
              con: userNameController,
              hintText: 'Username',
              icon: const Icon(Icons.person_3),
              length: 25,
            ),
            const SizedBox(height: 10),
            AuthTextField(
              con: passwordController,
              hintText: 'Password',
              isHidden: true,
              icon: const Icon(Icons.password),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  final bool isLoading = ref.watch(authStateProvider);
                  return isLoading
                      ? ElevatedButton(
                          onPressed: () {},
                          child: const CircularProgressIndicator())
                      : ElevatedButton(
                          child: const Text('LogIn'),
                          onPressed: () async {
                            final isLoggedin = await ref
                                .read(authStateProvider.notifier)
                                .login(userNameController.text,
                                    passwordController.text);

                            if (isLoggedin && mounted) {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HomeScreen()),
                                  (route) => false);
                            }
                          });
                },
              ),
            ),
            const SizedBox(height: 10),
            Text.rich(TextSpan(text: 'Don\'t have an account? ', children: [
              TextSpan(
                  text: 'Register',
                  style: const TextStyle(
                    color: Colors.lightBlue,
                    fontWeight: FontWeight.bold,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const RegisterScreen()));
                    })
            ]))
          ],
        ),
      ),
    );
  }
}
