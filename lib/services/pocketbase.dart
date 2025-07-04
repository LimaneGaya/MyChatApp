import 'package:image/image.dart'
    show Image, decodeImage, encodeJpg, copyResize, quantize;
import 'package:image_picker/image_picker.dart';
import 'package:mychatapp/services/pocketbase_web.dart'
    if (dart.library.io) 'package:mychatapp/services/pocketbase_none_web.dart'
    as pocket;
import 'package:flutter/foundation.dart' show Uint8List, debugPrint;
import 'package:http/http.dart' show MultipartFile;
import 'package:http_parser/http_parser.dart' show MediaType;
import 'package:pocketbase/pocketbase.dart';
import 'dart:math' as math;

class PB {
  static PocketBase pb = pocket.pb;
  static const int fetchCount = 30;

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
        "sender": pb.authStore.record!.id,
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

  static Future<List<RecordModel>> getMessages(String record,
      {int page = 1}) async {
    final res = await pb.collection('messages').getList(
          page: page,
          perPage: fetchCount,
          filter: 'conversation = "$record"',
          sort: '-created',
        );
    return res.items;
  }

  static Future<List<RecordModel>> getUsers({int page = 1}) async {
    final result = await pb.collection('users').getList(
          page: page,
          perPage: fetchCount,
          filter: 'id != "${pb.authStore.record!.id}"',
          sort: '-lastSeen',
        );
    return result.items;
  }

  static Future<List<RecordModel>> getConversation({int page = 1}) async {
    final res = await pb.collection('converstion').getList(
          page: page,
          perPage: fetchCount,
          filter: 'participants ~ "${pb.authStore.record!.id}"',
          expand: 'participants',
          sort: '-created',
        );
    return res.items;
  }

  static Future<void> deleteConvertation(String id) async {
    await pb.collection('converstion').delete(id);
  }

  static String getFileUrl(
      String id, String colId, String colNam, String name) {
    return pb.files
        .getUrl(
          RecordModel(
              {"id": id, "collectionId": colId, "collectionName": colNam}),
          name,
        )
        .toString();
  }

  static Future<void> updateUserLastSeen() async {
    if (pb.authStore.record == null) return;
    await pb.collection('users').update(
      pb.authStore.record!.id,
      body: {
        "lastSeen": DateTime.now().toUtc().toString(),
      },
    );
  }

  static void subscribe(
    String collection,
    Function(RecordSubscriptionEvent) func,
  ) {
    pb.collection(collection).subscribe('*', func);
  }

  static Future<RecordModel> getUserDetails(String id, {int page = 1}) async {
    final result =
        await pb.collection('user_details').getFirstListItem('user="$id"');
    return result;
  }

  static Future<void> uploadReport(String content, Uint8List uImage) async {
    Image? image = decodeImage(uImage);
    quantize(image!);
    image.exif.clear();
    var scaleW = image.width / 1024;
    var scaleH = image.height / 1024;
    var scale = math.max(1.0, math.min(scaleW, scaleH));
    image = copyResize(
      image,
      width: image.width ~/ scale,
      height: image.height ~/ scale,
    );
    List<int> pngData = encodeJpg(image, quality: 25);

    List<MultipartFile> file = [];

    file.add(
      MultipartFile.fromBytes('image', pngData,
          filename: '${DateTime.now().toUtc().microsecondsSinceEpoch}.jpg',
          contentType: MediaType('image', 'jpg')),
    );

    try {
      await pb.collection('reports').create(
          body: {"content": content, "user": pb.authStore.record!.id},
          files: file);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<void> updateToken(String token) async {
    await pb.collection('users').update(
      pb.authStore.record!.id,
      body: {
        "token": token,
      },
    );
  }

  static Future<List<RecordModel>> getMatches() async {
    debugPrint('getting matches');
    final result = await pb.collection('users').getList(
          perPage: fetchCount,
          sort: '@random',
          //filter: 'gender = "${'woman'}"',
        );
    return result.items;
  }

  static Future<RecordModel> setMatch(String id) async {
    return await pb.collection('matches').create(
      body: {
        "user": pb.authStore.record!.id,
        "match": id,
      },
    );
  }

  static Future<List<RecordModel>> getMatchedList() async {
    debugPrint('getting matched list');
    final result = await pb.collection('matches').getList(
          perPage: fetchCount,
          sort: '-created',
          filter: 'match = "${pb.authStore.record!.id}"',
          expand: 'user',
        );
    return result.items;
  }

  static Future<RecordModel> register(
    String password,
    String passwordConfirm,
    int age,
    bool isMan,
    String? name,
    String country,
  ) async {
    final body = <String, dynamic>{
      //"email": "test@example.com",
      "password": password,
      "passwordConfirm": passwordConfirm,
      "name": name,
      "lastSeen": DateTime.now().toUtc().toString(),
      "gender": isMan ? 'man' : 'woman',
      "age": age,
      "country_code": country,
    };

    return await pb.collection('users').create(body: body);
  }
}
