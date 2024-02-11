import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show Consumer, WidgetRef;
import 'package:mychatapp/auth/widgets/auth_text_field.dart';
import 'package:mychatapp/home_screen.dart';
import 'package:mychatapp/provider.dart' show authStateProvider;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  bool canSeePassword = false;
  bool isMale = false;
  int age = 18;
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
                hintText: 'User Name',
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
                  onChanged: (value) => setState(() => isMale = value!),
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
                  onChanged: (value) => setState(() => isMale = value!),
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
                length: 2),
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
                          child: const Text('Register'),
                          onPressed: () async {
                            final isLoggedin = await ref
                                .read(authStateProvider.notifier)
                                .register(
                                  password: passwordController.text,
                                  name: userNameController.text,
                                  isMan: isMale,
                                  age: int.parse(ageController.text),
                                  passwordConfirm: passwordController.text,
                                );

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
          ],
        ),
      ),
    );
  }
}
