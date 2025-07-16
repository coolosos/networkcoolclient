import 'package:http/src/response.dart';

import 'mock_client.dart';

final class MockNoAutoriceRequestClient extends MockClient {
  Response _response = Response('body', 401);

  void changeToSuccess() {
    _response = Response('body', 200);
  }

  void changeToNoAutorice() {
    _response = Response('body', 401);
  }

  @override
  Future<Response> get genericResponse async {
    return Future.delayed(const Duration(milliseconds: 300), () {
      return _response;
    });
  }
}
