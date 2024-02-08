import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mychatapp/models/models.dart';
import 'package:mychatapp/services/pocketbase.dart';

final userStateProvider =
    StateNotifierProvider<UserStateNotifier, List<UserModel>>(
  (ref) => UserStateNotifier(),
);

class UserStateNotifier extends StateNotifier<List<UserModel>> {
  int page = 0;
  UserStateNotifier() : super([]) {
    getUsers();
    //TODO: Uncoment This to: updateLastSeen();
  }

  void getUsers() async {
    //TODO: Implement better page loading with limit reached end case
    page = page + 1;
    final usersJson = await PB.getUsers(page: page);
    final data = usersJson.map((e) => UserModel.fromMap(e.toJson())).toList();

    state = state + data;
  }

  void updateLastSeen() async {
    await Future.delayed(const Duration(minutes: 1));
    await PB.updateUserLastSeen();
    updateLastSeen();
  }
}
