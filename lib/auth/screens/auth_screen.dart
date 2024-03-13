import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mychatapp/auth/provider/auth_provider.dart';
import 'package:mychatapp/auth/widgets/auth_text_field.dart';
import 'package:mychatapp/home_screen.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  bool isMale = false;
  int age = 18;
  int index = 0;

  @override
  void initState() {
    super.initState();
    ref.read(authStateProvider.notifier).authchanged(context);
  }

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoading = ref.watch(authStateProvider);
    return Scaffold(
      body: IndexedStack(
        index: index,
        children: [
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Chatly',
                            style: GoogleFonts.tangerine(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 50,
                                color: Colors.purple,
                              ),
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
                            child: ElevatedButton(
                                child: const Text('LogIn'),
                                onPressed: () async {
                                  final isLoggedin = await ref
                                      .read(authStateProvider.notifier)
                                      .login(context, userNameController.text,
                                          passwordController.text);

                                  if (isLoggedin && context.mounted) {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const HomeScreen()),
                                        (route) => false);
                                  }
                                }),
                          ),
                          const SizedBox(height: 10),
                          Text.rich(TextSpan(
                              text: 'Don\'t have an account? ',
                              children: [
                                TextSpan(
                                    text: 'Register',
                                    style: const TextStyle(
                                      color: Colors.lightBlue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => setState(() {
                                            index = 1;
                                          }))
                              ]))
                        ],
                      ),
                    ),
                  ),
                ),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Chatly',
                            style: GoogleFonts.tangerine(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 50,
                                color: Colors.purple,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          AuthTextField(
                              con: userNameController,
                              hintText: 'Name',
                              icon: const Icon(Icons.person_3),
                              length: 25),
                          const SizedBox(height: 10),
                          AuthTextField(
                              con: passwordController,
                              hintText: 'Password',
                              icon: const Icon(Icons.password),
                              isHidden: true),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const SizedBox(width: 50),
                              Radio(
                                value: false,
                                groupValue: isMale,
                                onChanged: (value) =>
                                    setState(() => isMale = value!),
                              ),
                              const Text('Female')
                            ],
                          ),
                          Row(
                            children: [
                              const SizedBox(width: 50),
                              Radio(
                                value: true,
                                groupValue: isMale,
                                onChanged: (value) =>
                                    setState(() => isMale = value!),
                              ),
                              const Text('Male')
                            ],
                          ),
                          const SizedBox(height: 10),
                          AuthTextField(
                            con: ageController,
                            isNumber: true,
                            hintText: 'Age',
                            icon: const Icon(Icons.person_3),
                            length: 2,
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              child: const Text('Register'),
                              onPressed: () async {
                                final parse = int.tryParse(ageController.text);
                                if (parse == null) {
                                  showDialog(
                                      context: context,
                                      builder: (context) => const AlertDialog(
                                          content: Text(
                                              'Please enter a valid number for age.')));
                                  return;
                                }
                                if (parse < 18) {
                                  showDialog(
                                      context: context,
                                      builder: (context) => const AlertDialog(
                                          content: Text(
                                              'You have to be 18 or older to register.')));
                                  return;
                                }
                                final isLoggedin = await ref
                                    .read(authStateProvider.notifier)
                                    .register(
                                      context,
                                      password: passwordController.text,
                                      name: userNameController.text,
                                      isMan: isMale,
                                      age: parse,
                                      passwordConfirm: passwordController.text,
                                    );

                                if (isLoggedin && context.mounted) {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const HomeScreen()),
                                      (route) => false);
                                }
                              },
                            ),
                          ),
                          Text.rich(TextSpan(
                              text: 'Already have an account? ',
                              children: [
                                TextSpan(
                                  text: 'Login',
                                  style: const TextStyle(
                                    color: Colors.lightBlue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => setState(() {
                                          index = 0;
                                        }),
                                )
                              ]))
                        ],
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
