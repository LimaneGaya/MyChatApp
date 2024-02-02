import 'package:pocketbase/pocketbase.dart';

class PB {
  static PocketBase pb = PocketBase('https://chatly-app.pockethost.io/');
  static String getUrl(RecordModel model, String filename) {
    return pb.files.getUrl(model, filename).toString();
  }
}
