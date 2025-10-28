import 'package:ncc/ncc.dart';

import 'mock_client.dart';

final class MockInfinityRequestClient extends MockClient {
  @override
  Future<Response> get genericResponse => Future<Response>.delayed(
        const Duration(hours: 1),
        () => Response('body', 200),
      );
}
