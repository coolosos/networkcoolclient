import 'dart:io';

import 'package:network_cool_client/network_cool_client.dart';

final class MyHttpClient extends HttpClient {
  MyHttpClient()
      : super(
          id: 'my-http-client',
          client: Client(),
          defaultHeaders: {
            HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
            'app-version': '1.0.0',
            'Age': '80000',
          },
        );

  @override
  Map<String, String> normalizeHeaders(Map<String, String>? headers) {
    return super.normalizeHeaders(headers)..remove('Age');
  }
}

void main() async {
  final client = MyHttpClient();

  final response = await client
      .get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));

  print(response.body);
}
