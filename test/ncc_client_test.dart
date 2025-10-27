import 'dart:async';

import 'package:ncc/ncc.dart';

import 'package:test/test.dart';

import 'clients/mock_client_exception.dart';
import 'clients/mock_infinity_request_client.dart';
import 'clients/mock_socket_exception.dart';
import 'clients/mock_success_request_client.dart';
import 'clients/mock_undermantenance_client_exception.dart';

final class TestNccClient extends NccClient {
  TestNccClient({
    required super.client,
    required super.id,
    super.timeout = const Duration(milliseconds: 200),
    super.defaultHeaders,
  });
}

// ignore: must_be_immutable reason: test
final class NormalizeTestNccClient extends TestNccClient {
  NormalizeTestNccClient({
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
      final testTimeOutClient = TestNccClient(
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
      final testSuccessClient = TestNccClient(
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
      final testSocketException = TestNccClient(
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
      final testClientException = TestNccClient(
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
      final testClientException = TestNccClient(
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
          final normalizeHeaders = NormalizeTestNccClient(
            client: MockSuccessRequestClient(),
            id: 'normalizeHeaders',
            defaultHeaders: const {
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
