import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:http_parser/http_parser.dart' show MediaType;

class PB {
  static PocketBase pb = PocketBase('https://chatly-app.pockethost.io/');
  static String getUrl(RecordModel model, String filename) {
    return pb.files.getUrl(model, filename).toString();
  }

  static Future<RecordModel> createMessage({
    required String conversationId,
    required String content,
    List<XFile> files = const [],
  }) async {
    final List<Uint8List> filesAsBytes = [];
    for (XFile file in files) {
      filesAsBytes.add(await file.readAsBytes());
    }
    return pb.collection('messages').create(
      body: {
        "conversation": conversationId,
        "sender": pb.authStore.model.id,
        "content": content,
      },
      files: filesAsBytes
          .asMap()
          .entries
          .map(
            (e) => MultipartFile.fromBytes(
              'file',
              e.value,
              filename: files[e.key].name,
              contentType: MediaType(
                'image',
                files[e.key].name.split('.').last,
              ),
            ),
          )
          .toList(),
    );
  }

  static Future<List<RecordModel>> getMessages(String record) async {
    final res = await pb.collection('messages').getList(
          page: 1,
          perPage: 50,
          filter: 'conversation = "$record"',
          sort: '-created',
        );
    return res.items;
  }

  static Future<List<RecordModel>> getUsers({int page = 1}) async {
    debugPrint('home initial id: ${pb.authStore.model.id}');
    final result = await pb.collection('users').getList(
          page: page,
          perPage: 20,
          filter: 'id != "${pb.authStore.model.id}"',
        );
    return result.items;
  }

  static Future<List<RecordModel>> getConversation({int page = 1}) async {
    debugPrint('home initial id: ${pb.authStore.model.id}');
    final res = await pb.collection('converstion').getList(
          page: page,
          perPage: 20,
          filter: 'participants ~ "${pb.authStore.model.id}"',
          expand: 'participants',
        );
    return res.items;
  }

  static void subscribe(
    String collection,
    Function(RecordSubscriptionEvent) func,
  ) {
    pb.collection(collection).subscribe('*', func);
  }
}
