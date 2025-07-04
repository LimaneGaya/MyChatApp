import 'package:fetch_client/fetch_client.dart';
import 'package:pocketbase/pocketbase.dart';

final PocketBase pb = PocketBase(
  'https://chatly.pockethost.io/',
  httpClientFactory: () => FetchClient(mode: RequestMode.cors),
);
