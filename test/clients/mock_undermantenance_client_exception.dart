import 'package:ncc/network_cool_client.dart';

import 'mock_client.dart';

final class MockUndermantenanceClientException extends MockClient {
  @override
  Future<Response> get genericResponse async =>
      Response('Undermantenance', 503);
}
