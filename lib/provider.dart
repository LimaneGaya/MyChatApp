import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authStateProvider = StateNotifierProvider<AuthStateNotifier, bool>(
  (ref) => AuthStateNotifier(sharedPrefs: ref.watch(sharedPrefProvider).value!),
);
final sharedPrefProvider = FutureProvider<SharedPreferences>(
  (ref) => SharedPreferences.getInstance(),
);
final messagesProvider =
    FutureProvider.family((ref, String conversation) async {
  final messages = await ref
      .watch(authStateProvider.notifier)
      .pb
      .collection('messages')
      .getList();
  print(messages.items.map((e) => e.data['content']).toList());
});

class AuthStateNotifier extends StateNotifier<bool> {
  final SharedPreferences _sharedPref;
  AuthStateNotifier({required SharedPreferences sharedPrefs})
      : _sharedPref = sharedPrefs,
        super(false);

  final _pocketbase = PocketBase('http://127.0.0.1:8090');

  PocketBase get pb => _pocketbase;

  Future<bool> login(String userName, String password) async {
    state = true;
    final authData = await _pocketbase
        .collection('users')
        .authWithPassword(userName, password);
    if (authData.record != null) {
      authData.record!;
      final data = jsonEncode({
        'token': authData.token,
        'record': authData.record,
      });
      await _sharedPref.setString('auth', data);
    }
    state = false;
    return _pocketbase.authStore.isValid;
  }

  bool checkIfLogedIn() {
    //TODO: Add check to see if user was deleted or banned
    final auth = _sharedPref.getString('auth');
    if (auth == null) return false;
    final decoded = jsonDecode(auth) as Map<String, dynamic>;
    final String token = decoded['token'];
    final record =
        RecordModel.fromJson(decoded['record'] as Map<String, dynamic>);
    _pocketbase.authStore.save(token, record);
    return _pocketbase.authStore.isValid;
  }

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth');
    _pocketbase.authStore.clear();
  }
}
