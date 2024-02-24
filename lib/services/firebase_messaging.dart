import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mychatapp/services/env.dart';
import 'package:mychatapp/services/pocketbase.dart';

final firebaseMessagingProvider = Provider(
  (ref) => FCM(),
);

class FCM {
  final pb = PB.pb;
  FCM() {
    setFCM();
  }

  setFCM() async {
    await FirebaseMessaging.instance.requestPermission(provisional: true);
    String? apnsToken;
    apnsToken ??= await getNotificationToken();
    apnsToken ??= await getNotificationToken();
    apnsToken ??= await getNotificationToken();
    apnsToken ??= await getNotificationToken();
    apnsToken ??= await getNotificationToken();
    apnsToken ??= await getNotificationToken();
    apnsToken ??= await getNotificationToken();
    apnsToken ??= await getNotificationToken();
    debugPrint(apnsToken);
    if (apnsToken != null) PB.updateToken(apnsToken);
    FirebaseMessaging.instance.onTokenRefresh.listen(PB.updateToken);
  }

  Future<String?> getNotificationToken() =>
      FirebaseMessaging.instance.getToken(vapidKey: Env.vapidkey);
}
