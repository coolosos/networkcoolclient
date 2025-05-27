import 'package:network_cool_client/network_cool_client.dart';

import 'mock_client.dart';

final class MockSaveCookieClient extends MockClient {
  MockSaveCookieClient({required this.cookie});
  final String cookie;
  @override
  Future<Response> get genericResponse async => Response(
        'Save cookie',
        200,
        headers: {
          HttpHeaders.setCookieHeader: cookie,
        },
      );
}
