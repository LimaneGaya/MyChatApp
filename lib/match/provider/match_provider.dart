import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mychatapp/models/models.dart';
import 'package:mychatapp/services/pocketbase.dart';

final matchProvider = ChangeNotifierProvider<MatchChangeNotifier>(
  (ref) => MatchChangeNotifier(),
);

class MatchChangeNotifier extends ChangeNotifier {
  int index = 0;
  List<UserModel> matches = [];

  Future<void> getMatches() async {
    final m = await PB.getMatches();
    matches = m.map((e) => UserModel.fromMap(e.toJson())).toList();
    notifyListeners();
  }

  void like() async {
    print('like ${matches[index].name}');
    next();
  }

  void dislike() {
    print('dislike ${matches[index].name}');
    next();
  }

  void next() async {
    index++;
    notifyListeners();

    if (index >= matches.length - 1) {
      await getMatches();
      index = 0;
    }
  }
}
