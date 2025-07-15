library;

import 'dart:async';
import 'dart:convert';
import 'dart:io' show SocketException, HttpStatus, HttpHeaders;

import 'package:http/http.dart';
import '../network_observer/network_observer.dart';
import '../network_observer/on_response.dart';
import '../network_state.dart';
import 'package:meta/meta.dart';

import '../network_exceptions.dart';

part 'client_methods.dart';
part 'http_client.dart';
part 'session_client.dart';
part 'network_observable.dart';

/// A typedef representing a function that sends an HTTP request
/// using the provided headers and returns a [Future<Response>].
typedef RequestSender = Future<Response> Function(Map<String, String> headers);

/// An abstract base class that implements the [ClientMethods] interface,
/// providing a foundation for custom HTTP clients.
///
/// This class wraps an instance of [Client] from the `http` package and
/// provides a consistent implementation of all standard HTTP methods.
/// It also includes a unique [id] to identify the client instance,
/// which is useful when managing multiple clients in an application.
///
/// Subclasses must implement [executeRequest] to define how requests
/// are handled, including custom behavior such as logging, header manipulation,
/// retry logic, etc.
abstract class BaseClient implements ClientMethods {
  /// Creates a new [BaseClient] with the given [client] and unique [id].
  ///
  /// The [client] is used to perform the actual HTTP operations.
  /// The [id] helps uniquely identify this client instance.
  const BaseClient({
    required this.client,
    required this.id,
  });

  /// The underlying HTTP client used to perform requests.
  final Client client;

  /// A unique identifier for this client instance.
  final String id;

  @override
  Future<Response> delete(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) =>
      executeRequest(
        headers: normalizeHeaders(headers),
        send: (finalHeaders) => client.delete(
          url,
          headers: finalHeaders,
          body: body,
          encoding: encoding,
        ),
      );

  @override
  Future<Response> get(
    Uri url, {
    Map<String, String>? headers,
  }) =>
      executeRequest(
        headers: normalizeHeaders(headers),
        send: (finalHeaders) => client.get(
          url,
          headers: finalHeaders,
        ),
      );

  @override
  Future<Response> head(
    Uri url, {
    Map<String, String>? headers,
  }) =>
      executeRequest(
        headers: normalizeHeaders(headers),
        send: (finalHeaders) => client.head(
          url,
          headers: finalHeaders,
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
        headers: normalizeHeaders(headers),
        send: (finalHeaders) => client.patch(
          url,
          headers: finalHeaders,
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
        headers: normalizeHeaders(headers),
        send: (finalHeaders) => client.post(
          url,
          headers: finalHeaders,
          body: body,
          encoding: encoding,
        ),
      );

  @override
  Future<Response> put(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) =>
      executeRequest(
        headers: normalizeHeaders(headers),
        send: (finalHeaders) => client.put(
          url,
          headers: finalHeaders,
          body: body,
          encoding: encoding,
        ),
      );

  /// Executes the HTTP request using the provided [send] function and [headers].
  ///
  /// This method must be implemented by subclasses to apply custom logic
  /// (e.g., modifying headers, error handling, retries, logging, etc.)
  /// before sending the request through the underlying [Client].
  ///
  /// - [headers]: The headers to include in the request.
  /// - [send]: A function that takes finalized headers and sends the request.
  @protected
  @visibleForTesting
  Future<Response> executeRequest({
    required Map<String, String> headers,
    required RequestSender send,
  });

  /// Ensures headers are not null by returning an empty map if necessary.
  ///
  /// Can be overridden by subclasses to apply custom header processing,
  /// such as injecting default headers or transforming key casing.
  @protected
  Map<String, String> normalizeHeaders(Map<String, String>? headers) {
    return headers ?? <String, String>{};
  }

  /// Checks whether the server is currently under maintenance based on the given [response].
  ///
  /// This method should inspect the response content, status code, or headers
  /// to determine if the server is signaling a maintenance state (e.g., 503 Service Unavailable).
  ///
  /// Subclasses can override this to customize detection based on specific API behavior.
  @protected
  bool checkUnderMaintenance(Response response);

  @override
  String toString() => 'BaseClient(id: $id)';

  @override
  bool operator ==(covariant BaseClient other) {
    if (identical(this, other)) return true;

    return other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
