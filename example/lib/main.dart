import 'dart:developer';
import 'dart:io';

import 'custom_client/custom_ncc_client.dart';
import 'custom_client/custom_session_client.dart';
import 'observer/custom_network_observer.dart';

Future<void> main(List<String> args) async {
  final client = MyNccClient();
  final sessionClient = MySessionClient()
    ..addObserver(
      CustomNetworkObserver(
        onNotLoggedIn: () async {
          log('Not logged in');
        },
        onOffline: () async {
          log('offline');
        },
        onUndermantenance: () async {
          log('onUndermantenance');
        },
      ),
    );

  final noSessionRequest = await client
      .get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));

  log(
    'Response body from no session ${noSessionRequest.body}\n${noSessionRequest.request?.headers}',
  );

  await sessionClient
      .get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));

  exit(1);
}
