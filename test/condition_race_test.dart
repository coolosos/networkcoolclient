import 'dart:async';

import 'package:ncc/ncc.dart';
import 'package:test/test.dart';

import 'clients/mock_unauthorized_request_client.dart';

final class TestSessionBearerClient extends SessionClient {
  TestSessionBearerClient({
    required super.id,
    required super.client,
    required this.bearerToken,
    super.timeout = const Duration(
      milliseconds: 500,
    ),
    super.defaultHeaders,
  });

  final String? bearerToken;

  @override
  Future<String?> getBearerToken() async {
    return bearerToken;
  }

  @override
  Future<bool> renewSession() async {
    numberOfExecution = numberOfExecution + 1;
    await Future.delayed(const Duration(milliseconds: 150));
    client.changeToSuccess();
    return true;
  }
}

double numberOfExecution = 0;
final client = MockUnauthorizedRequestClient();

void main() {
  group(
    'Condition Race',
    () {
      final testConditionRace = TestSessionBearerClient(
        client: client,
        id: 'testSessionBearerClient',
        bearerToken: 'AwesomeBearToken',
      );

      test(
        'Execution condition race',
        () async {
          unawaited(
            testConditionRace.get(
              Uri.dataFromString('test_dart.es'),
            ),
          );

          unawaited(
            testConditionRace.get(
              Uri.dataFromString('test_dart1.es'),
            ),
          );

          /// This delay is the enough delay for waiting the call and bit more for no execute the next line in sequential
          await Future.delayed(
            const Duration(milliseconds: 350),
          );
          await testConditionRace.get(
            Uri.dataFromString('test_dart2.es'),
          );

          expect(
            numberOfExecution,
            1,
          );
        },
      );
      numberOfExecution = 0;
      client.changeToUnauthorized();

      test(
        'Multiple renew token',
        () async {
          unawaited(
            testConditionRace.get(
              Uri.dataFromString('test_dart.es'),
            ),
          );

          unawaited(
            testConditionRace.get(
              Uri.dataFromString('test_dart1.es'),
            ),
          );

          /// This delay is the enough delay for waiting the call and waiting the renew token
          await Future.delayed(
            const Duration(milliseconds: 500),
          );

          /// Change to unauthorized for get the renew token again
          client.changeToUnauthorized();

          await testConditionRace.get(
            Uri.dataFromString('test_dart2.es'),
          );

          expect(
            numberOfExecution,
            2,
          );
        },
      );
    },
  );
}
