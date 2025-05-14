import 'package:network_cool_client/network_cool_client.dart';
import 'package:test/test.dart';

import 'clients/mock_success_request_client.dart';
import 'clients/mock_undermantenance_client_exception.dart';
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
    'Observer group',
    () {
      test(
        'Observer on response',
        () async {
          final observer = ClientObserver();
          final TestHttpClient successRequestHttpClient = TestHttpClient(
            client: MockSuccessRequestClient(),
            id: 'successRequestHttpClient',
          )..addObserver(observer);
          try {
            await successRequestHttpClient.get(
              Uri.dataFromString('test_dart.es'),
              headers: {'key': 'key'},
            );
          } catch (_) {}
          expect(
            observer.callingActions.contains(ClientObserverAction.onResponse),
            true,
          );
        },
      );
      test(
        'on change status',
        () async {
          final observer = ClientObserver();
          final TestHttpClient underMantenance = TestHttpClient(
            client: MockUndermantenanceClientException(),
            id: 'underMantenance',
          )..addObserver(observer);
          try {
            await underMantenance.get(
              Uri.dataFromString('test_dart.es'),
              headers: {'key': 'key'},
            );
          } catch (_) {}
          expect(
            observer.callingActions
                .contains(ClientObserverAction.onChangeNetworkStatus),
            true,
          );
        },
      );
      test(
        'on error',
        () async {
          final observer = ClientObserver();
          final TestHttpClient underMantenance = TestHttpClient(
            client: MockUndermantenanceClientException(),
            id: 'underMantenance',
          )..addObserver(observer);
          try {
            await underMantenance.get(
              Uri.dataFromString('test_dart.es'),
              headers: {'key': 'key'},
            );
          } catch (_) {}
          expect(
            observer.callingActions.contains(ClientObserverAction.onError),
            true,
          );
        },
      );
      test(
        'on dispose',
        () async {
          final observer = ClientObserver();
          final TestHttpClient underMantenance = TestHttpClient(
            client: MockUndermantenanceClientException(),
            id: 'underMantenance',
          )..addObserver(observer);
          underMantenance.dispose();
          expect(
            observer.callingActions.contains(ClientObserverAction.onDispose),
            true,
          );
          expect(
            underMantenance.isObservable,
            false,
          );
        },
      );
    },
  );
}
