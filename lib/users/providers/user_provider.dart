import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mychatapp/models/models.dart';
import 'package:mychatapp/services/pocketbase.dart';

final userStateProvider =
    StateNotifierProvider<UserStateNotifier, List<UserModel>>(
  (ref) => UserStateNotifier(),
);

class UserStateNotifier extends StateNotifier<List<UserModel>> {
  UserStateNotifier() : super([]) {
    getUsers();
    //TODO: Uncoment This / updateLastSeen();
  }

  void getUsers() async {
    final usersJson = await PB.getUsers();
    state = usersJson.map((e) => UserModel.fromMap(e.toJson())).toList();
  }

  void updateLastSeen() async {
    await Future.delayed(const Duration(minutes: 1));
    await PB.updateUserLastSeen();
    updateLastSeen();
  }
}
