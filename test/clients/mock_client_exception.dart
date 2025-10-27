import 'package:ncc/ncc.dart';

import 'mock_client.dart';

final class MockClientException extends MockClient {
  @override
  Future<Response> get genericResponse => throw ClientException('Error');
}
