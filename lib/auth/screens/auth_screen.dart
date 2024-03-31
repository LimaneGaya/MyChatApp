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
  final formKeyLogin = GlobalKey<FormState>();
  final formKeyRegister = GlobalKey<FormState>();

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
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 500),
                        child: Form(
                          key: formKeyLogin,
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
                                verify: (value) {
                                  value = value?.trim();

                                  if (value == null || value.isEmpty) {
                                    return 'Please enter username';
                                  }
                                  if (value.length < 4 || value.length > 25) {
                                    return 'Username must be between 3 and 25 characters';
                                  }
                                  if (!RegExp(r'^[a-zA-Z0-9]+$')
                                      .hasMatch(value)) {
                                    return 'Username must not contain special characters';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              AuthTextField(
                                con: passwordController,
                                hintText: 'Password',
                                isHidden: true,
                                icon: const Icon(Icons.password),
                                verify: (value) {
                                  value = value?.trim();
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter password';
                                  }
                                  if (value.length < 6 || value.length > 25) {
                                    return 'Password must be between 6 and 25 characters';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                    child: const Text('LogIn'),
                                    onPressed: () async {
                                      if (!formKeyLogin.currentState!
                                          .validate()) return;
                                      final isLoggedin = await ref
                                          .read(authStateProvider.notifier)
                                          .login(
                                              context,
                                              userNameController.text,
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
                  ),
                ),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 500),
                        child: Form(
                          key: formKeyRegister,
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
                                length: 25,
                                verify: (value) {
                                  value = value?.trim();
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter name';
                                  }
                                  if (value.length < 4 || value.length > 25) {
                                    return 'Name must be between 3 and 25 characters';
                                  }
                                  if (!RegExp(r'^[a-zA-Z0-9]+$')
                                      .hasMatch(value)) {
                                    return 'Name must not contain special characters';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              AuthTextField(
                                  con: passwordController,
                                  hintText: 'Password',
                                  icon: const Icon(Icons.password),
                                  isHidden: true,
                                  verify: (value) {
                                    value = value?.trim();
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter password';
                                    }
                                    if (value.length < 6 || value.length > 25) {
                                      return 'Password must be between 6 and 25 characters';
                                    }
                                    return null;
                                  }),
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
                                verify: (value) {
                                  value = value?.trim();
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter age';
                                  }
                                  if (value.length < 2 || value.length > 2) {
                                    return 'Age must be 2 characters';
                                  }
                                  if (int.tryParse(value) == null) {
                                    return 'Please enter a valid number';
                                  }
                                  if (int.parse(value) < 18) {
                                    return 'You have to be 18 or older to register';
                                  }

                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  child: const Text('Register'),
                                  onPressed: () async {
                                    if (!formKeyRegister.currentState!
                                        .validate()) return;
                                    final isLoggedin = await ref
                                        .read(authStateProvider.notifier)
                                        .register(
                                          context,
                                          password:
                                              passwordController.text.trim(),
                                          name: userNameController.text.trim(),
                                          isMan: isMale,
                                          age: int.parse(
                                              ageController.text.trim()),
                                          passwordConfirm:
                                              passwordController.text.trim(),
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
                  ),
                ),
        ],
      ),
    );
  }
}
