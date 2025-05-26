import 'package:network_cool_client/network_cool_client.dart';

import '../observer/custom_network_observer.dart';

final class MySessionClient extends SessionClient {
  MySessionClient()
      : super(
          id: 'my-session-client',
          client: Client(),
        );

  @override
  Future<String?> getBearerToken() async {
    // Replace with secure storage or other mechanism
    return 'example-bearer-token';
  }

  @override
  Future<bool> renewSession() async {
    // Implement your session renewal logic here
    return true;
  }
}

void main() async {
  final client = MySessionClient()
    ..addObserver(
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

  final response = await client
      .get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));

  print(response.body);
}
