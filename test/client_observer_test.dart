import 'package:ncc/network_cool_client.dart';
import 'package:test/test.dart';

import 'clients/mock_session_broke_exception.dart';
import 'clients/mock_success_request_client.dart';
import 'clients/mock_undermantenance_client_exception.dart';
import 'observer/client_observer.dart';
import 'session_client_test.dart';

final class TestNccClient extends NccClient {
  TestNccClient({
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
          final successRequestNccClient = TestNccClient(
            client: MockSuccessRequestClient(),
            id: 'successRequestNccClient',
          )..addObserver(observer);
          try {
            await successRequestNccClient.get(
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
          final underMantenance = TestNccClient(
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
          final underMantenance = TestNccClient(
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
          final underMantenance = TestNccClient(
            client: MockUndermantenanceClientException(),
            id: 'underMantenance',
          )
            ..addObserver(observer)
            ..dispose();
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

      test(
        'Not logged in exception',
        () async {
          final observer = ClientObserver();
          final mockBrokenSession = MockSessionBrokeException();
          final testClientException = TestSessionBrokenClient(
            client: mockBrokenSession,
            id: 'MockSessionBrokeException',
          )..addObserver(observer);

          await expectLater(
            () => testClientException.get(
              Uri.dataFromString('test_dart.es'),
              headers: {'key': 'key'},
            ),
            throwsA(
              isA<NotLoggedInException>(),
            ),
          );
          expect(observer.callingActions, [
            ClientObserverAction.onResponse,
            ClientObserverAction.onChangeNetworkStatus,
            ClientObserverAction.onError,
          ]);
        },
      );
    },
  );
}
