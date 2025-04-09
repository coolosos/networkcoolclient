import 'network_cool_client.dart';

final class Test extends HttpClient {
  Test({required super.client, required super.id});

  @override
  Map<String, String> normalizeHeaders(Map<String, String>? headers) {
    // TODO: implement normalizeHeaders
    return super.normalizeHeaders(headers);
  }
}
