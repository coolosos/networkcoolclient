part of 'base_client.dart';

abstract interface class ClientMethods {
  const ClientMethods();

  Future<Response> head(
    Uri url, {
    Map<String, String>? headers,
  });

  Future<Response> get(
    Uri url, {
    Map<String, String>? headers,
  });

  Future<Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  });

  Future<Response> put(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  });

  Future<Response> patch(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  });

  Future<Response> delete(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  });
}
