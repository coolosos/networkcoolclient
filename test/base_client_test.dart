import 'package:network_cool_client/network_cool_client.dart';
import 'package:test/test.dart';

import 'clients/mock_infinity_request_client.dart';
import 'clients/mock_success_request_client.dart';
import 'observer/client_observer.dart';

final class TestHttpClient extends HttpClient {
  TestHttpClient({
    required super.client,
    required super.id,
    super.timeout = const Duration(milliseconds: 200),
  });
}

void main() {
  group(
    'Base function',
    () {
      test(
        'toString function',
        () async {
          final TestHttpClient successRequestHttpClient = TestHttpClient(
            client: MockSuccessRequestClient(),
            id: 'successRequestHttpClient',
          );

          expect(
            successRequestHttpClient.toString(),
            'BaseClient(id: ${successRequestHttpClient.id})',
          );
        },
      );
      test(
        'Operator == different ',
        () async {
          final TestHttpClient successRequestHttpClient = TestHttpClient(
            client: MockSuccessRequestClient(),
            id: 'successRequestHttpClient',
          );

          final TestHttpClient infinityClient = TestHttpClient(
            client: MockInfinityRequestClient(),
            id: 'infinityClient',
          );
          expect(
            successRequestHttpClient == infinityClient,
            false,
          );
        },
      );
      test(
        'Operator == same id',
        () async {
          final TestHttpClient successRequestHttpClient = TestHttpClient(
            client: MockSuccessRequestClient(),
            id: 'successRequestHttpClient',
          );

          final TestHttpClient infinityClient = TestHttpClient(
            client: MockInfinityRequestClient(),
            id: 'successRequestHttpClient',
          );
          expect(
            successRequestHttpClient == infinityClient,
            true,
          );
        },
      );
      test(
        'Operator == identical',
        () async {
          final TestHttpClient successRequestHttpClient = TestHttpClient(
            client: MockSuccessRequestClient(),
            id: 'successRequestHttpClient',
          );
          final TestHttpClient successRequestHttpClientIdentical =
              TestHttpClient(
            client: MockSuccessRequestClient(),
            id: 'successRequestHttpClient',
          );

          expect(
            successRequestHttpClient == successRequestHttpClientIdentical,
            true,
          );
        },
      );

      test(
        'hashCode',
        () async {
          final TestHttpClient successRequestHttpClient = TestHttpClient(
            client: MockSuccessRequestClient(),
            id: 'successRequestHttpClient',
          );

          expect(
            successRequestHttpClient.hashCode > 0,
            true,
          );
        },
      );

      final observer = ClientObserver();
      final TestHttpClient observerChecker = TestHttpClient(
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
    },
  );
}
