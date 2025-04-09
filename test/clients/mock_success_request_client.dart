import 'package:http/src/response.dart';

import 'mock_client.dart';

final class MockSuccessRequestClient extends MockClient {
  @override
  Future<Response> get genericResponse async => Response('body', 200);
}
