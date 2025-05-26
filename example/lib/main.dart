import 'dart:io';

import 'custom_client/custom_http_client.dart';
import 'custom_client/custom_session_client.dart';
import 'observer/custom_network_observer.dart';

Future<void> main(List<String> args) async {
  final client = MyHttpClient();
  final sessionClient = MySessionClient();

  sessionClient.addObserver(
    CustomNetworkObserver(
      onNotLoggedIn: () async {
        print('Not logged in');
      },
      onOffline: () async {
        print('offline');
      },
      onUndermantenance: () async {
        print('onUndermantenance');
      },
    ),
  );

  final noSessionRequest = await client
      .get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));

  print(
    "Response body from no session ${noSessionRequest.body}\n${noSessionRequest.request?.headers}",
  );

  await sessionClient
      .get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));

  exit(1);
}
