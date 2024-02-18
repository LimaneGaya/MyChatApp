import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mychatapp/models/models.dart';
import 'package:mychatapp/services/pocketbase.dart';

final userStateProvider =
    StateNotifierProvider<UserStateNotifier, List<UserModel>>(
  (ref) => UserStateNotifier(),
);

final userDetailsProvider = FutureProvider.family
    .autoDispose((ref, String id) => PB.getUserDetails(id));

class UserStateNotifier extends StateNotifier<List<UserModel>> {
  bool isDoneFetching = false;
  UserStateNotifier() : super([]) {
    //TODO: Uncoment This to update last seen
    //updateLastSeen();
  }

  void getNextUsers({int page = 1}) async {
    if (isDoneFetching) return;
    final usersJson = await PB.getUsers(page: page);
    if (usersJson.length < PB.fetchCount) isDoneFetching = true;
    final data = usersJson.map((e) => UserModel.fromMap(e.toJson())).toList();

    state = state + data;
  }

  void updateLastSeen() async {
    await Future.delayed(const Duration(minutes: 1));
    await PB.updateUserLastSeen();
    updateLastSeen();
  }
}
