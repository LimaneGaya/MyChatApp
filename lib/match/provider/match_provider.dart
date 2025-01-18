import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mychatapp/models/models.dart';
import 'package:mychatapp/services/pocketbase.dart';

final matchProvider = StateNotifierProvider<MatchStateNotifier, UserModel?>(
  (ref) => MatchStateNotifier(),
);
final userImagesProvider = FutureProvider.family
    .autoDispose((ref, String id) => PB.getUserDetails(id));

final matchedListProvide = FutureProvider((ref) async {
  final m = await PB.getMatchedList();
  return m
      .map((e) => UserModel.fromMap(e.get('expand.user')![0].toJson()))
      .toList();
});

class MatchStateNotifier extends StateNotifier<UserModel?> {
  int index = 0;
  List<UserModel> matches = [];
  bool _loading = false;

  MatchStateNotifier() : super(null) {
    getMatches();
  }

  Future<void> getMatches() async {
    _loading = true;
    final m = await PB.getMatches();
    matches = m.map((e) => UserModel.fromMap(e.toJson())).toList();
    index = 0;
    state = matches[index];
    _loading = false;
  }

  void like() async {
    PB.setMatch(matches[index].id);
    debugPrint('like ${matches[index].name}');
    next();
  }

  void dislike() {
    debugPrint('dislike ${matches[index].name}');
    next();
  }

  void next() async {
    index++;

    if (index >= matches.length && !_loading) {
      state = null;
      return getMatches();
    }

    state = matches[index];
  }
}
