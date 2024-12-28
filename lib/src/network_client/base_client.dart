library;

import 'dart:async';
import 'dart:convert';
import 'dart:io' show SocketException, HttpStatus, HttpHeaders;

import 'package:mutex/mutex.dart';

import 'package:http/http.dart';
import 'package:network_cool_client/src/network_observer/network_observer.dart';
import 'package:network_cool_client/src/network_observer/on_response.dart';
import 'package:network_cool_client/src/network_state.dart';

import '../network_exceptions.dart';

part 'client_methods.dart';
part 'http_client.dart';
part 'session_client.dart';
part 'network_observable.dart';

abstract class BaseClient implements ClientMethods {
  const BaseClient({required this.client, required this.key});

  final Client client;

  final String key;

  @override
  Future<Response> delete(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) =>
      executeRequest(
        headers: headers,
        send: (managedHeaders) => client.delete(
          url,
          headers: managedHeaders,
          body: body,
          encoding: encoding,
        ),
      );

  @override
  Future<Response> get(
    Uri url, {
    Map<String, String>? headers,
  }) {
    return executeRequest(
      headers: headers,
      send: (managedHeaders) => client.get(
        url,
        headers: managedHeaders,
      ),
    );
  }

  @override
  Future<Response> head(
    Uri url, {
    Map<String, String>? headers,
  }) =>
      executeRequest(
        headers: headers,
        send: (managedHeaders) => client.head(
          url,
          headers: managedHeaders,
        ),
      );

  @override
  Future<Response> patch(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) =>
      executeRequest(
        headers: headers,
        send: (managedHeaders) => client.patch(
          url,
          headers: managedHeaders,
          body: body,
          encoding: encoding,
        ),
      );

  @override
  Future<Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) =>
      executeRequest(
        headers: headers,
        send: (managedHeaders) {
          return client.post(
            url,
            headers: managedHeaders,
            body: body,
            encoding: encoding,
          );
        },
      );

  @override
  Future<Response> put(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) =>
      executeRequest(
        headers: headers,
        send: (managedHeaders) => client.put(
          url,
          headers: managedHeaders,
          body: body,
          encoding: encoding,
        ),
      );

  Future<Response> executeRequest({
    required Map<String, String>? headers,
    required Future<Response> Function(Map<String, String> headers) send,
  });
}
