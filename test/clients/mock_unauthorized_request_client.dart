import 'package:http/src/response.dart';

import 'mock_client.dart';

final class MockUnauthorizedRequestClient extends MockClient {
  Response _response = Response('body', 401);

  void changeToSuccess() {
    _response = Response('body', 200);
  }

  void changeToUnauthorized() {
    _response = Response('body', 401);
  }

  @override
  Future<Response> get genericResponse async {
    return Future.delayed(const Duration(milliseconds: 300), () {
      return _response;
    });
  }
}
