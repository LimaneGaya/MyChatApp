import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show StateNotifierProvider, FutureProvider, StateNotifier;
import 'package:mychatapp/auth/screens/auth_screen.dart';
import 'package:mychatapp/home_screen.dart';
import 'package:mychatapp/services/pocketbase.dart';
import 'package:pocketbase/pocketbase.dart' show RecordModel;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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

  void authchanged(BuildContext context) {
    _pb.authStore.onChange.listen((event) {
      if (event.model?.id == null) {
        logout(context);
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false);
      }
    });
  }

  Future<bool> login(
      BuildContext context, String userName, String password) async {
    state = true;
    try {
      final authData =
          await _pb.collection('users').authWithPassword(userName, password);
      if (authData.record != null) {
        final data = jsonEncode({
          'token': authData.token,
          'record': authData.record,
        });
        await _sharedPref.setString('auth', data);
      } else {
        showDialog(
            // ignore: use_build_context_synchronously
            context: context,
            builder: (context) =>
                const AlertDialog(content: Text('Wrong username or password')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Center(child: Text(e.toString())),
        ));
      }
    }

    state = false;
    return _pb.authStore.isValid;
  }

  Future<bool> register(
    BuildContext context, {
    required String password,
    required String passwordConfirm,
    required int age,
    required bool isMan,
    String? name,
  }) async {
    state = true;
    final String country = await getPosition();
    final RecordModel record = await PB.register(
      password,
      passwordConfirm,
      age,
      isMan,
      name,
      country,
    );
    // ignore: use_build_context_synchronously
    return await login(context, record.data['username'], password);
  }

  Future<String> getPosition() async {
    var url = Uri.http('ip-api.com', 'json', {'fields': 'status,countryCode'});
    return await http.get(url).then((value) {
      if (value.statusCode == 200) {
        final decoded = jsonDecode(value.body);
        if (decoded['status'] == 'success') {
          return decoded['countryCode'] as String;
        } else {
          return '';
        }
      } else {
        return '';
      }
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return '';
    });
  }

  Future<void> logout(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth');
    _pb.authStore.clear();
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const AuthScreen(),
          ),
          (route) => false);
    }
  }
}
