import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    try {
      apnsToken = await getNotificationToken();
      apnsToken = await getNotificationToken();
      apnsToken = await getNotificationToken();
    } catch (e) {
      try {
        apnsToken = await getNotificationToken();
      } catch (e) {
        try {
          apnsToken = await getNotificationToken();
        } catch (e) {
          debugPrint(e.toString());
        }
      }
    }
    if (apnsToken != null) PB.updateToken(apnsToken);
    FirebaseMessaging.instance.onTokenRefresh.listen(PB.updateToken);
  }

  Future<String?> getNotificationToken() => FirebaseMessaging.instance.getToken(
      vapidKey: 'BGdFmH81mQRXyROc_64sE-q74R8qkP2dJLNuJlUTIcXCP'
          '4u5Wvpoop6_k8nwhzEWv-Xp9gLmmVv8Z1W63rGifIM');
}
