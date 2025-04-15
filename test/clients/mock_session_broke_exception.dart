import 'dart:io' show HttpStatus;

import 'package:http/src/response.dart';

import 'mock_client.dart';

final class MockSessionBrokeException extends MockClient {
  bool isSecondTime = false;
  int count = 0;
  @override
  Future<Response> get genericResponse async {
    if (isSecondTime) {
      count = count + 1;
      return Response('FixSession', 200);
    }
    isSecondTime = true;
    count = count + 1;
    return Response('SessionBroke', HttpStatus.unauthorized);
  }

  void refreshSecondTime() {
    isSecondTime = false;
    count = 0;
  }
}
