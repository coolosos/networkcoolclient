part of 'base_client.dart';

/// An abstract interface that defines the contract for an HTTP client.
///
/// This interface outlines the basic HTTP methods that a client should
/// implement in order to perform network requests such as `GET`, `POST`,
/// `PUT`, `PATCH`, `DELETE`, and `HEAD`.
///
/// Each method returns a [Future<Response>] that completes with the
/// server's response.
abstract interface class ClientMethods {
  /// Sends an HTTP HEAD request to the given [url].
  ///
  /// Only the headers are returned in the response, not the body.
  ///
  /// Optional [headers] can be included in the request.
  Future<Response> head(
    Uri url, {
    Map<String, String>? headers,
  });

  /// Sends an HTTP GET request to the given [url].
  ///
  /// Optional [headers] can be included in the request.
  Future<Response> get(
    Uri url, {
    Map<String, String>? headers,
  });

  /// Sends an HTTP POST request to the given [url].
  ///
  /// Optional [headers] can be provided to customize the request.
  /// The [body] can be any JSON-encodable object or raw content.
  /// The [encoding] specifies how the body should be encoded.
  Future<Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  });

  /// Sends an HTTP PUT request to the given [url].
  ///
  /// Optional [headers] can be provided to customize the request.
  /// The [body] can be any JSON-encodable object or raw content.
  /// The [encoding] specifies how the body should be encoded.
  Future<Response> put(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  });

  /// Sends an HTTP PATCH request to the given [url].
  ///
  /// Optional [headers] can be provided to customize the request.
  /// The [body] can be any JSON-encodable object or raw content.
  /// The [encoding] specifies how the body should be encoded.
  Future<Response> patch(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  });

  /// Sends an HTTP DELETE request to the given [url].
  ///
  /// Optional [headers] can be provided to customize the request.
  /// The [body] can be any JSON-encodable object or raw content.
  /// The [encoding] specifies how the body should be encoded.
  Future<Response> delete(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  });
}
