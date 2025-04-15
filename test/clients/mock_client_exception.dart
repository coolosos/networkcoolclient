import 'package:network_cool_client/network_cool_client.dart';

import 'mock_client.dart';

final class MockClientException extends MockClient {
  @override
  Future<Response> get genericResponse => throw ClientException('Error');
}
