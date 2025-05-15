import 'dart:async';

import 'package:network_cool_client/network_cool_client.dart';

import 'package:test/test.dart';

import 'clients/mock_client_exception.dart';
import 'clients/mock_infinity_request_client.dart';
import 'clients/mock_socket_exception.dart';
import 'clients/mock_success_request_client.dart';
import 'clients/mock_undermantenance_client_exception.dart';

final class TestHttpClient extends HttpClient {
  TestHttpClient({
    required super.client,
    required super.id,
    super.timeout = const Duration(milliseconds: 200),
    super.defaultHeaders,
  });
}

final class NormalizeTestHttpClient extends TestHttpClient {
  NormalizeTestHttpClient({
    required super.client,
    required super.id,
    super.timeout = const Duration(milliseconds: 200),
    super.defaultHeaders,
  });

  Map<String, String> headersChange = {};

  @override
  Future<Response> executeRequest({
    required Map<String, String> headers,
    required Future<Response> Function(Map<String, String> headers) send,
  }) {
    headersChange = headers;
    return super.executeRequest(headers: headers, send: send);
  }
}

void main() {
  group(
    'Timeout',
    () {
      final TestHttpClient testTimeOutClient = TestHttpClient(
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
      final TestHttpClient testSuccessClient = TestHttpClient(
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
      final TestHttpClient testSocketException = TestHttpClient(
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
              isA<SocketException>(),
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
              isA<SocketException>(),
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
              isA<SocketException>(),
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
              isA<SocketException>(),
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
              isA<SocketException>(),
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
              isA<SocketException>(),
            ),
          );
        },
      );
    },
  );
  group(
    'Client Exception',
    () {
      final TestHttpClient testClientException = TestHttpClient(
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
              isA<ClientException>(),
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
              isA<ClientException>(),
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
              isA<ClientException>(),
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
              isA<ClientException>(),
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
              isA<ClientException>(),
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
              isA<ClientException>(),
            ),
          );
        },
      );
    },
  );
  group(
    'Client Undermantenance',
    () {
      final TestHttpClient testClientException = TestHttpClient(
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
    'Normalize headers',
    () {
      test(
        'Test normalize function',
        () async {
          final NormalizeTestHttpClient normalizeHeaders =
              NormalizeTestHttpClient(
            client: MockSuccessRequestClient(),
            id: 'normalizeHeaders',
            defaultHeaders: {
              'key': 'key',
              'default': 'true',
            },
          );
          final newHeaders = {'key': 'callHeader', 'call': 'done'};
          await normalizeHeaders.get(
            Uri.parse('https://www.google.com/'),
            headers: newHeaders,
          );

          expect(
            normalizeHeaders.headersChange,
            {'key': 'callHeader', 'default': 'true', 'call': 'done'},
          );
        },
      );
    },
  );
}
