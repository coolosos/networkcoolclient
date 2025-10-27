import 'package:network_cool_client/network_cool_client.dart';
import 'package:test/test.dart';

import 'clients/mock_infinity_request_client.dart';
import 'clients/mock_success_request_client.dart';
import 'observer/client_observer.dart';

final class TestNccClient extends NccClient {
  TestNccClient({
    required super.client,
    required super.id,
    super.timeout = const Duration(milliseconds: 200),
  });
}

// ignore: must_be_immutable reason: test
final class BaseClientTest extends BaseClient {
  BaseClientTest({required super.client, required super.id});

  Map<String, String> headersChange = {};

  @override
  bool checkUnderMaintenance(Response response) {
    return false;
  }

  @override
  Future<Response> executeRequest({
    required Map<String, String> headers,
    required RequestSender send,
  }) async {
    headersChange = headers;
    return Response('body', 200);
  }
}

void main() {
  group(
    'Base function',
    () {
      test(
        'BaseClientTest normalize function put call headers',
        () async {
          final normalizeClient = BaseClientTest(
            client: MockSuccessRequestClient(),
            id: 'normalizeClient',
          );
          final newHeaders = {'key': 'key'};
          await normalizeClient.get(
            Uri.parse('https://www.google.com/'),
            headers: newHeaders,
          );

          expect(
            normalizeClient.headersChange,
            newHeaders,
          );
          normalizeClient.headersChange = {};

          await normalizeClient.get(
            Uri.parse('https://www.google.com/'),
          );

          expect(
            normalizeClient.headersChange,
            {},
          );
        },
      );
      test(
        'toString function',
        () async {
          final successRequestNccClient = TestNccClient(
            client: MockSuccessRequestClient(),
            id: 'successRequestNccClient',
          );

          expect(
            successRequestNccClient.toString(),
            'BaseClient(id: ${successRequestNccClient.id})',
          );
        },
      );
      test(
        'Operator == different ',
        () async {
          final successRequestNccClient = TestNccClient(
            client: MockSuccessRequestClient(),
            id: 'successRequestNccClient',
          );

          final infinityClient = TestNccClient(
            client: MockInfinityRequestClient(),
            id: 'infinityClient',
          );
          expect(
            successRequestNccClient == infinityClient,
            false,
          );
        },
      );
      test(
        'Operator == same id',
        () async {
          final successRequestNccClient = TestNccClient(
            client: MockSuccessRequestClient(),
            id: 'successRequestNccClient',
          );

          final infinityClient = TestNccClient(
            client: MockInfinityRequestClient(),
            id: 'successRequestNccClient',
          );
          expect(
            successRequestNccClient == infinityClient,
            true,
          );
        },
      );
      test(
        'Operator == identical',
        () async {
          final successRequestNccClient = TestNccClient(
            client: MockSuccessRequestClient(),
            id: 'successRequestNccClient',
          );
          final successRequestNccClientIdentical = TestNccClient(
            client: MockSuccessRequestClient(),
            id: 'successRequestNccClient',
          );

          expect(
            successRequestNccClient == successRequestNccClientIdentical,
            true,
          );
        },
      );

      test(
        'hashCode',
        () async {
          final successRequestNccClient = TestNccClient(
            client: MockSuccessRequestClient(),
            id: 'successRequestNccClient',
          );

          expect(
            successRequestNccClient.hashCode > 0,
            true,
          );
        },
      );

      final observer = ClientObserver();
      final observerChecker = TestNccClient(
        client: MockSuccessRequestClient(),
        id: 'observerChecker',
      );

      final noObserverChecker = TestNccClient(
        client: MockSuccessRequestClient(),
        id: 'observerChecker',
      );

      test(
        'on add observer',
        () async {
          observerChecker.addObserver(observer);
          expect(
            observerChecker.isObservable,
            true,
          );
          expect(noObserverChecker.isObservable, false);
        },
      );

      test(
        'on remove observer',
        () async {
          observerChecker.removeObserver(observer);
          expect(
            observerChecker.isObservable,
            false,
          );
        },
      );

      final globalObserver = ClientObserver();
      final globalObserverChecker = TestNccClient(
        client: MockSuccessRequestClient(),
        id: 'observerChecker',
      );

      final noGlobalObserverChecker = TestNccClient(
        client: MockSuccessRequestClient(),
        id: 'observerChecker',
      );

      test(
        'on add global observer',
        () async {
          GlobalNetworkObservable.addObserver(globalObserver);
          expect(
            globalObserverChecker.isObservable,
            false,
          );
          expect(noGlobalObserverChecker.isObservable, false);

          expect(
            globalObserverChecker.isGlobalObservable,
            true,
          );
          expect(noGlobalObserverChecker.isGlobalObservable, true);
        },
      );

      test(
        'on remove global observer',
        () async {
          GlobalNetworkObservable.removeObserver(globalObserver);
          expect(
            globalObserverChecker.isObservable,
            false,
          );

          expect(
            noGlobalObserverChecker.isGlobalObservable,
            false,
          );
        },
      );

      test(
        'on dispose global observer',
        () async {
          GlobalNetworkObservable.addObserver(globalObserver);
          GlobalNetworkObservable.dispose();
          expect(
            GlobalNetworkObservable.observers,
            <NetworkObserver>{},
          );
        },
      );
    },
  );
}
