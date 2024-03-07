import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mychatapp/models/models.dart';
import 'package:mychatapp/services/pocketbase.dart';

final matchProvider = StateNotifierProvider<MatchStateNotifier, UserModel?>(
  (ref) => MatchStateNotifier(),
);
final userImagesProvider = FutureProvider.family
    .autoDispose((ref, String id) => PB.getUserDetails(id));

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
    print('like ${matches[index].name}');
    next();
  }

  void dislike() {
    print('dislike ${matches[index].name}');
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
