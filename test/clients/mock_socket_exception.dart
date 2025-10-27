import 'package:ncc/ncc.dart';

import 'mock_client.dart';

final class MockSocketException extends MockClient {
  @override
  Future<Response> get genericResponse => throw const SocketException('Error');
}
