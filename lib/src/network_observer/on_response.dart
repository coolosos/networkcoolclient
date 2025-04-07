import 'dart:typed_data';

/// A class that encapsulates the details of an HTTP response received
/// from a server. It includes various properties that describe the content
/// and status of the response, such as the body, status code, and reason phrase.
base class OnResponse {
  /// Creates an instance of [OnResponse] with optional parameters.
  ///
  /// - [uri]: The URI of the request that generated this response.
  /// - [body]: The body of the response as a string (typically the content returned from the server).
  /// - [bodyBytes]: The body of the response as raw bytes (useful for binary data).
  /// - [statusCode]: The HTTP status code returned by the server (e.g., 200, 404, etc.).
  /// - [reasonPhrase]: A brief textual explanation of the HTTP status (e.g., "OK", "Not Found").
  OnResponse({
    this.uri,
    this.body,
    this.bodyBytes,
    this.statusCode,
    this.reasonPhrase,
  });

  /// The body of the response as a string. It contains the content returned
  /// from the server in the response. This is typically used for textual content.
  final String? body;

  /// The body of the response as raw bytes. This is used when the response contains binary data.
  final Uint8List? bodyBytes;

  /// The reason phrase accompanying the status code. It provides a brief description
  /// of the HTTP status returned by the server, such as "OK" for 200 or "Not Found" for 404.
  final String? reasonPhrase;

  /// The HTTP status code returned by the server (e.g., 200 for success, 404 for not found).
  final int? statusCode;

  /// The URI of the request that resulted in this response. This is the URL or endpoint
  /// that was accessed when making the request to the server.
  final Uri? uri;
}
