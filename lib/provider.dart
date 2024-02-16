import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show StateNotifierProvider, FutureProvider, StateNotifier;
import 'package:mychatapp/login_screen.dart';
import 'package:mychatapp/services/pocketbase.dart';
import 'package:pocketbase/pocketbase.dart' show RecordModel;
import 'package:shared_preferences/shared_preferences.dart';

final authStateProvider = StateNotifierProvider<AuthStateNotifier, bool>(
  (ref) => AuthStateNotifier(sharedPrefs: ref.watch(sharedPrefProvider).value!),
);
final sharedPrefProvider = FutureProvider<SharedPreferences>(
  (ref) => SharedPreferences.getInstance(),
);
final authCheckifLoginIsValid = FutureProvider<bool>((ref) async {
  final pb = PB.pb;
  final sharedPref = ref.watch(sharedPrefProvider).value!;
  final auth = sharedPref.getString('auth');
  if (auth == null) return false;
  final decoded = jsonDecode(auth) as Map<String, dynamic>;
  final String token = decoded['token'];
  final record =
      RecordModel.fromJson(decoded['record'] as Map<String, dynamic>);
  pb.authStore.save(token, record);
  final newRecord = await pb.collection('users').authRefresh();
  if (newRecord.record == null) return false;
  final data =
      jsonEncode({'token': newRecord.token, 'record': newRecord.record});
  await sharedPref.setString('auth', data);
  return true;
});

class AuthStateNotifier extends StateNotifier<bool> {
  final SharedPreferences _sharedPref;
  AuthStateNotifier({required SharedPreferences sharedPrefs})
      : _sharedPref = sharedPrefs,
        super(false);
  final _pb = PB.pb;

  Future<bool> login(String userName, String password) async {
    state = true;
    final authData =
        await _pb.collection('users').authWithPassword(userName, password);
    if (authData.record != null) {
      authData.record!;
      final data =
          jsonEncode({'token': authData.token, 'record': authData.record});
      await _sharedPref.setString('auth', data);
    }
    state = false;
    return _pb.authStore.isValid;
  }

  Future<bool> register({
    required String password,
    required String passwordConfirm,
    required int age,
    required bool isMan,
    String? name,
  }) async {
    state = true;
    final body = <String, dynamic>{
      //"email": "test@example.com",
      "password": password,
      "passwordConfirm": passwordConfirm,
      "name": name,
      "lastSeen": DateTime.now().toUtc().toString(),
      "gender": isMan ? 'man' : 'woman',
      "age": age
    };

    final record = await _pb.collection('users').create(body: body);
    return await login(record.data['username'], password);
  }

  Future<void> logout(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth');
    _pb.authStore.clear();
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
          (route) => false);
    }
  }
}
