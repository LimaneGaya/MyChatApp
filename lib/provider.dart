import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketbase/pocketbase.dart';

final pocketbaseProvider = Provider(
  (ref) => PocketBase('http://127.0.0.1:8090'),
);
