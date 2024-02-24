import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show Consumer, WidgetRef;
import 'package:google_fonts/google_fonts.dart';
import 'package:mychatapp/auth/screens/login_screen.dart';
import 'package:mychatapp/auth/widgets/auth_text_field.dart';
import 'package:mychatapp/home_screen.dart';
import 'package:mychatapp/auth/provider/auth_provider.dart'
    show authStateProvider;
import 'package:http/http.dart ' as http;

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
  String country = '';
  @override
  void initState() {
    super.initState();
    getPosition();
  }

  void getPosition() async {
    var url = Uri.http('ip-api.com', 'json', {'fields': 'status,countryCode'});
    http.get(url).then((value) {
      if (value.statusCode == 200) {
        final decoded = jsonDecode(value.body);
        if (decoded['status'] == 'success') {
          country = ['countryCode'] as String;
        } else {
          getPosition();
        }
      } else {
        getPosition();
      }
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
                    builder: (
                      BuildContext context,
                      WidgetRef ref,
                      Widget? child,
                    ) {
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
                                      context,
                                      password: passwordController.text,
                                      name: userNameController.text,
                                      isMan: isMale,
                                      age: int.parse(ageController.text),
                                      passwordConfirm: passwordController.text,
                                      countryCode: country,
                                    );

                                if (isLoggedin && context.mounted) {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const HomeScreen()),
                                      (route) => false);
                                }
                              });
                    },
                  ),
                ),
                Text.rich(
                    TextSpan(text: 'Already have an account? ', children: [
                  TextSpan(
                      text: 'Login',
                      style: const TextStyle(
                        color: Colors.lightBlue,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                        })
                ]))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
