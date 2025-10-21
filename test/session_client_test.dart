import 'dart:async';

import 'package:network_cool_client/network_cool_client.dart';

import 'package:test/test.dart';

import 'clients/mock_client_exception.dart';
import 'clients/mock_infinity_request_client.dart';
import 'clients/mock_save_cookie_client.dart';
import 'clients/mock_session_broke_exception.dart';
import 'clients/mock_socket_exception.dart';
import 'clients/mock_success_request_client.dart';
import 'clients/mock_undermantenance_client_exception.dart';

final class TestSessionClient extends SessionClient {
  TestSessionClient({
    required super.id,
    required super.client,
    super.timeout = const Duration(
      milliseconds: 200,
    ),
  });

  @override
  Future<String?> getBearerToken() async {
    return 'BearToken';
  }

  @override
  Future<bool> renewSession() async {
    return true;
  }
}

final class TestSessionBearerClient extends SessionClient {
  TestSessionBearerClient({
    required super.id,
    required super.client,
    required this.bearerToken,
    super.timeout = const Duration(
      milliseconds: 200,
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
    return true;
  }
}

final class TestSessionBrokenClient extends SessionClient {
  TestSessionBrokenClient({
    required super.id,
    required super.client,
    super.timeout = const Duration(
      milliseconds: 200,
    ),
  });

  @override
  Future<String?> getBearerToken() async {
    return 'BearToken';
  }

  @override
  Future<bool> renewSession() async {
    return false;
  }
}

void main() {
  group(
    'Timeout',
    () {
      final testTimeOutClient = TestSessionClient(
        client: MockInfinityRequestClient(),
        id: 'testTimeOutClient',
      );

      test(
        'Get timeout',
        () {
          expect(
            () async => testTimeOutClient.get(
              Uri.dataFromString('test_dart.es'),
              headers: {'key': 'key'},
            ),
            throwsA(
              isA<TimeoutException>(),
            ),
          );
        },
      );
      test(
        'Post timeout',
        () {
          expect(
            () async => testTimeOutClient.post(
              Uri.dataFromString('test_dart.es'),
            ),
            throwsA(
              isA<TimeoutException>(),
            ),
          );
        },
      );
      test(
        'Delete timeout',
        () {
          expect(
            () async => testTimeOutClient.delete(
              Uri.dataFromString('test_dart.es'),
              headers: {'key': 'key'},
            ),
            throwsA(
              isA<TimeoutException>(),
            ),
          );
        },
      );
      test(
        'Head timeout',
        () {
          expect(
            () async => testTimeOutClient.head(
              Uri.dataFromString('test_dart.es'),
              headers: {'key': 'key'},
            ),
            throwsA(
              isA<TimeoutException>(),
            ),
          );
        },
      );
      test(
        'Patch timeout',
        () {
          expect(
            () async => testTimeOutClient.patch(
              Uri.dataFromString('test_dart.es'),
              headers: {'key': 'key'},
            ),
            throwsA(
              isA<TimeoutException>(),
            ),
          );
        },
      );
      test(
        'Put timeout',
        () {
          expect(
            () async => testTimeOutClient.put(
              Uri.dataFromString('test_dart.es'),
              headers: {'key': 'key'},
            ),
            throwsA(
              isA<TimeoutException>(),
            ),
          );
        },
      );
    },
  );
  group(
    'Successful',
    () {
      final testSuccessClient = TestSessionClient(
        client: MockSuccessRequestClient(),
        id: 'MockSuccessRequestClient',
      );
      test(
        'Get success',
        () async {
          final request = await testSuccessClient.get(
            Uri.dataFromString('test_dart.es'),
            headers: {'key': 'key'},
          );
          expect(
            request.statusCode,
            200,
          );
        },
      );
      test(
        'Post success',
        () async {
          final request = await testSuccessClient.post(
            Uri.dataFromString('test_dart.es'),
            headers: {'key': 'key'},
          );
          expect(
            request.statusCode,
            200,
          );
        },
      );
      test(
        'Delete success',
        () async {
          final request = await testSuccessClient.delete(
            Uri.dataFromString('test_dart.es'),
            headers: {'key': 'key'},
          );
          expect(
            request.statusCode,
            200,
          );
        },
      );
      test(
        'Head success',
        () async {
          final request = await testSuccessClient.head(
            Uri.dataFromString('test_dart.es'),
            headers: {'key': 'key'},
          );
          expect(
            request.statusCode,
            200,
          );
        },
      );
      test(
        'Patch success',
        () async {
          final request = await testSuccessClient.patch(
            Uri.dataFromString('test_dart.es'),
            headers: {'key': 'key'},
          );
          expect(
            request.statusCode,
            200,
          );
        },
      );
      test(
        'Put success',
        () async {
          final request = await testSuccessClient.put(
            Uri.dataFromString('test_dart.es'),
            headers: {'key': 'key'},
          );
          expect(
            request.statusCode,
            200,
          );
        },
      );
    },
  );
  group(
    'Socket Exception',
    () {
      final testSocketException = TestSessionClient(
        client: MockSocketException(),
        id: 'MockSocketException',
      );
      test(
        'Get socket exception',
        () {
          expect(
            () => testSocketException.get(
              Uri.dataFromString('test_dart.es'),
              headers: {'key': 'key'},
            ),
            throwsA(
              isA<NetworkAvailabilityException>(),
            ),
          );
        },
      );
      test(
        'Post socket exception',
        () {
          expect(
            () => testSocketException.post(
              Uri.dataFromString('test_dart.es'),
              headers: {'key': 'key'},
            ),
            throwsA(
              isA<NetworkAvailabilityException>(),
            ),
          );
        },
      );
      test(
        'Delete socket exception',
        () {
          expect(
            () => testSocketException.delete(
              Uri.dataFromString('test_dart.es'),
              headers: {'key': 'key'},
            ),
            throwsA(
              isA<NetworkAvailabilityException>(),
            ),
          );
        },
      );
      test(
        'Head socket exception',
        () {
          expect(
            () => testSocketException.head(
              Uri.dataFromString('test_dart.es'),
              headers: {'key': 'key'},
            ),
            throwsA(
              isA<NetworkAvailabilityException>(),
            ),
          );
        },
      );
      test(
        'Patch socket exception',
        () {
          expect(
            () => testSocketException.patch(
              Uri.dataFromString('test_dart.es'),
              headers: {'key': 'key'},
            ),
            throwsA(
              isA<NetworkAvailabilityException>(),
            ),
          );
        },
      );
      test(
        'Put socket exception',
        () {
          expect(
            () => testSocketException.put(
              Uri.dataFromString('test_dart.es'),
              headers: {'key': 'key'},
            ),
            throwsA(
              isA<NetworkAvailabilityException>(),
            ),
          );
        },
      );
    },
  );
  group(
    'Client Exception',
    () {
      final testClientException = TestSessionClient(
        client: MockClientException(),
        id: 'MockClientException',
      );
      test(
        'Get client exception',
        () {
          expect(
            () => testClientException.get(
              Uri.dataFromString('test_dart.es'),
              headers: {'key': 'key'},
            ),
            throwsA(
              isA<NetworkAvailabilityException>(),
            ),
          );
        },
      );
      test(
        'Post client exception',
        () {
          expect(
            () => testClientException.post(
              Uri.dataFromString('test_dart.es'),
              headers: {'key': 'key'},
            ),
            throwsA(
              isA<NetworkAvailabilityException>(),
            ),
          );
        },
      );
      test(
        'Delete client exception',
        () {
          expect(
            () => testClientException.delete(
              Uri.dataFromString('test_dart.es'),
              headers: {'key': 'key'},
            ),
            throwsA(
              isA<NetworkAvailabilityException>(),
            ),
          );
        },
      );
      test(
        'Head client exception',
        () {
          expect(
            () => testClientException.head(
              Uri.dataFromString('test_dart.es'),
              headers: {'key': 'key'},
            ),
            throwsA(
              isA<NetworkAvailabilityException>(),
            ),
          );
        },
      );
      test(
        'Patch client exception',
        () {
          expect(
            () => testClientException.patch(
              Uri.dataFromString('test_dart.es'),
              headers: {'key': 'key'},
            ),
            throwsA(
              isA<NetworkAvailabilityException>(),
            ),
          );
        },
      );
      test(
        'Put client exception',
        () {
          expect(
            () => testClientException.put(
              Uri.dataFromString('test_dart.es'),
              headers: {'key': 'key'},
            ),
            throwsA(
              isA<NetworkAvailabilityException>(),
            ),
          );
        },
      );
    },
  );
  group(
    'Client Undermantenance',
    () {
      final testClientException = TestSessionClient(
        client: MockUndermantenanceClientException(),
        id: 'MockUndermantenanceClientException',
      );
      test(
        'Get client Undermantenance',
        () {
          expect(
            () => testClientException.get(
              Uri.dataFromString('test_dart.es'),
              headers: {'key': 'key'},
            ),
            throwsA(
              isA<ServerAvailabilityException>(),
            ),
          );
        },
      );
      test(
        'Post client Undermantenance',
        () {
          expect(
            () => testClientException.post(
              Uri.dataFromString('test_dart.es'),
              headers: {'key': 'key'},
            ),
            throwsA(
              isA<ServerAvailabilityException>(),
            ),
          );
        },
      );
      test(
        'Delete client Undermantenance',
        () {
          expect(
            () => testClientException.delete(
              Uri.dataFromString('test_dart.es'),
              headers: {'key': 'key'},
            ),
            throwsA(
              isA<ServerAvailabilityException>(),
            ),
          );
        },
      );
      test(
        'Head client Undermantenance',
        () {
          expect(
            () => testClientException.head(
              Uri.dataFromString('test_dart.es'),
              headers: {'key': 'key'},
            ),
            throwsA(
              isA<ServerAvailabilityException>(),
            ),
          );
        },
      );
      test(
        'Patch client Undermantenance',
        () {
          expect(
            () => testClientException.patch(
              Uri.dataFromString('test_dart.es'),
              headers: {'key': 'key'},
            ),
            throwsA(
              isA<ServerAvailabilityException>(),
            ),
          );
        },
      );
      test(
        'Put client Undermantenance',
        () {
          expect(
            () => testClientException.put(
              Uri.dataFromString('test_dart.es'),
              headers: {'key': 'key'},
            ),
            throwsA(
              isA<ServerAvailabilityException>(),
            ),
          );
        },
      );
    },
  );
  group(
    'Client Session Broke Fixed',
    () {
      final mockBrokenSession = MockSessionBrokeException();
      final testClientException = TestSessionClient(
        client: mockBrokenSession,
        id: 'MockSessionBrokeException',
      );
      test(
        'Get client SessionBroke Fixed',
        () async {
          final response = await testClientException.get(
            Uri.dataFromString('test_dart.es'),
            headers: {'key': 'key'},
          );
          expect(mockBrokenSession.isSecondTime, true);
          expect(response.statusCode, 200);
          mockBrokenSession.refreshSecondTime();
        },
      );
      test(
        'Post client SessionBroke Fixed',
        () async {
          final response = await testClientException.post(
            Uri.dataFromString('test_dart.es'),
            headers: {'key': 'key'},
          );
          expect(mockBrokenSession.isSecondTime, true);
          expect(response.statusCode, 200);
          mockBrokenSession.refreshSecondTime();
        },
      );
      test(
        'Delete client SessionBroke Fixed',
        () async {
          final response = await testClientException.delete(
            Uri.dataFromString('test_dart.es'),
            headers: {'key': 'key'},
          );
          expect(mockBrokenSession.isSecondTime, true);
          expect(response.statusCode, 200);
          mockBrokenSession.refreshSecondTime();
        },
      );
      test(
        'Head client SessionBroke Fixed',
        () async {
          final response = await testClientException.head(
            Uri.dataFromString('test_dart.es'),
            headers: {'key': 'key'},
          );
          expect(mockBrokenSession.isSecondTime, true);
          expect(response.statusCode, 200);
          mockBrokenSession.refreshSecondTime();
        },
      );
      test(
        'Patch client SessionBroke Fixed',
        () async {
          final response = await testClientException.patch(
            Uri.dataFromString('test_dart.es'),
            headers: {'key': 'key'},
          );
          expect(mockBrokenSession.isSecondTime, true);
          expect(response.statusCode, 200);
          mockBrokenSession.refreshSecondTime();
        },
      );
      test(
        'Put client SessionBroke Fixed',
        () async {
          final response = await testClientException.put(
            Uri.dataFromString('test_dart.es'),
            headers: {'key': 'key'},
          );
          expect(mockBrokenSession.isSecondTime, true);
          expect(response.statusCode, 200);
          mockBrokenSession.refreshSecondTime();
        },
      );
    },
  );
  group(
    'Client Session Broken',
    () {
      final mockBrokenSession = MockSessionBrokeException();
      final testClientException =
          TestSessionBrokenClient(
        client: mockBrokenSession,
        id: 'MockSessionBrokeException',
      );
      test(
        'Get client Session Broken',
        () async {
          await expectLater(
            () => testClientException.get(
              Uri.dataFromString('test_dart.es'),
              headers: {'key': 'key'},
            ),
            throwsA(
              isA<NotLoggedInException>(),
            ),
          );
          expect(mockBrokenSession.count, 1);
          mockBrokenSession.refreshSecondTime();
        },
      );
      test(
        'Post client Session Broken',
        () async {
          await expectLater(
            () => testClientException.post(
              Uri.dataFromString('test_dart.es'),
              headers: {'key': 'key'},
            ),
            throwsA(
              isA<NotLoggedInException>(),
            ),
          );
          expect(mockBrokenSession.count, 1);
          mockBrokenSession.refreshSecondTime();
        },
      );
      test(
        'Delete client Session Broken',
        () async {
          await expectLater(
            () => testClientException.delete(
              Uri.dataFromString('test_dart.es'),
              headers: {'key': 'key'},
            ),
            throwsA(
              isA<NotLoggedInException>(),
            ),
          );
          expect(mockBrokenSession.count, 1);
          mockBrokenSession.refreshSecondTime();
        },
      );
      test(
        'Head client Session Broken',
        () async {
          await expectLater(
            () => testClientException.head(
              Uri.dataFromString('test_dart.es'),
              headers: {'key': 'key'},
            ),
            throwsA(
              isA<NotLoggedInException>(),
            ),
          );
          expect(mockBrokenSession.count, 1);
          mockBrokenSession.refreshSecondTime();
        },
      );
      test(
        'Patch client Session Broken',
        () async {
          await expectLater(
            () => testClientException.patch(
              Uri.dataFromString('test_dart.es'),
              headers: {'key': 'key'},
            ),
            throwsA(
              isA<NotLoggedInException>(),
            ),
          );
          expect(mockBrokenSession.count, 1);
          mockBrokenSession.refreshSecondTime();
        },
      );
      test(
        'Put client Session Broken',
        () async {
          await expectLater(
            () => testClientException.put(
              Uri.dataFromString('test_dart.es'),
              headers: {'key': 'key'},
            ),
            throwsA(
              isA<NotLoggedInException>(),
            ),
          );
          expect(mockBrokenSession.count, 1);
          mockBrokenSession.refreshSecondTime();
        },
      );

      test(
        'Get client Session Broken and then fixed',
        () async {
          final mockBrokenSession = MockSessionBrokeException();
          final testClientException = TestSessionBrokenClient(
            client: mockBrokenSession,
            id: 'MockSessionBrokeExceptionFixed',
          );

          // First call fails and sets state to notLoggedIn
          await expectLater(
            () => testClientException.get(
              Uri.dataFromString('test_dart.es'),
            ),
            throwsA(
              isA<NotLoggedInException>(),
            ),
          );
          expect(mockBrokenSession.count, 1);

          // Second call should succeed and cover the missing line
          final response = await testClientException.get(
            Uri.dataFromString('test_dart.es'),
          );
          expect(response.statusCode, 200);
        },
      );
    },
  );

  group(
    'Session header with Bearer Token',
    () {
      final defaultHeader = {'test': 'test'};
      test(
        'Bearer token Fail',
        () async {
          final testClientException =
              TestSessionBearerClient(
            bearerToken: null,
            client: MockSessionBrokeException(),
            id: 'MockSessionBrokeException',
          );
          final data = await testClientException.sessionHeaders(null);
          expect(data, <String, String>{});
        },
      );
      test(
        'Bearer token Fail with other headers',
        () async {
          final testClientException =
              TestSessionBearerClient(
            bearerToken: null,
            client: MockSessionBrokeException(),
            id: 'MockSessionBrokeException',
          );
          final data = await testClientException.sessionHeaders(defaultHeader);
          expect(data, defaultHeader);
        },
      );

      test(
        'Bearer token Success',
        () async {
          final testClientException =
              TestSessionBearerClient(
            bearerToken: 'token',
            client: MockSessionBrokeException(),
            id: 'MockSessionBrokeException',
          );
          final data = await testClientException.sessionHeaders(null);
          expect(data, <String, String>{
            HttpHeaders.authorizationHeader: 'Bearer token',
          });
        },
      );
      test(
        'Bearer token Success with defaultHeaders',
        () async {
          final testClientException =
              TestSessionBearerClient(
            bearerToken: 'token',
            client: MockSessionBrokeException(),
            id: 'MockSessionBrokeException',
          );
          final data = await testClientException.sessionHeaders(defaultHeader);
          expect(
            data,
            <String, String>{
              HttpHeaders.authorizationHeader: 'Bearer token',
            }..addAll(defaultHeader),
          );
        },
      );
    },
  );
  group(
    'Cookie saved',
    () {
      const cookie = 'cookie';
      final client = MockSaveCookieClient(cookie: cookie);
      test(
        'Get Cookie saved',
        () async {
          final testClientException =
              TestSessionBearerClient(
            bearerToken: null,
            client: client,
            id: 'MockSaveCookieClient',
          );
          final response = await testClientException.get(
            Uri.dataFromString('test_dart.es'),
            headers: {'key': 'key'},
          );
          final data = await testClientException.sessionHeaders(null);
          expect(data, <String, String>{HttpHeaders.cookieHeader: cookie});
          expect(response.statusCode, 200);
        },
      );
      test(
        'Post Cookie saved',
        () async {
          final testClientException =
              TestSessionBearerClient(
            bearerToken: null,
            client: client,
            id: 'MockSaveCookieClient',
          );
          final response = await testClientException.post(
            Uri.dataFromString('test_dart.es'),
            headers: {'key': 'key'},
          );
          final data = await testClientException.sessionHeaders(null);
          expect(data, <String, String>{HttpHeaders.cookieHeader: cookie});
          expect(response.statusCode, 200);
        },
      );
      test(
        'Delete Cookie saved',
        () async {
          final testClientException =
              TestSessionBearerClient(
            bearerToken: null,
            client: client,
            id: 'MockSaveCookieClient',
          );
          final response = await testClientException.delete(
            Uri.dataFromString('test_dart.es'),
            headers: {'key': 'key'},
          );
          final data = await testClientException.sessionHeaders(null);
          expect(data, <String, String>{HttpHeaders.cookieHeader: cookie});
          expect(response.statusCode, 200);
        },
      );
      test(
        'Head Cookie saved',
        () async {
          final testClientException =
              TestSessionBearerClient(
            bearerToken: null,
            client: client,
            id: 'MockSaveCookieClient',
          );
          final response = await testClientException.head(
            Uri.dataFromString('test_dart.es'),
            headers: {'key': 'key'},
          );
          final data = await testClientException.sessionHeaders(null);
          expect(data, <String, String>{HttpHeaders.cookieHeader: cookie});
          expect(response.statusCode, 200);
        },
      );
      test(
        'Patch Cookie saved',
        () async {
          final testClientException =
              TestSessionBearerClient(
            bearerToken: null,
            client: client,
            id: 'MockSaveCookieClient',
          );
          final response = await testClientException.patch(
            Uri.dataFromString('test_dart.es'),
            headers: {'key': 'key'},
          );
          final data = await testClientException.sessionHeaders(null);
          expect(data, <String, String>{HttpHeaders.cookieHeader: cookie});
          expect(response.statusCode, 200);
        },
      );
      test(
        'Put Cookie saved',
        () async {
          final testClientException =
              TestSessionBearerClient(
            bearerToken: null,
            client: client,
            id: 'MockSaveCookieClient',
          );
          final response = await testClientException.put(
            Uri.dataFromString('test_dart.es'),
            headers: {'key': 'key'},
          );
          final data = await testClientException.sessionHeaders(null);
          expect(data, <String, String>{HttpHeaders.cookieHeader: cookie});
          expect(response.statusCode, 200);
        },
      );
    },
  );
}
