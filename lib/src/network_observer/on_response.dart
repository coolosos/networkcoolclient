import 'dart:typed_data';

base class OnResponse {
  OnResponse({
    this.uri,
    this.body,
    this.bodyBytes,
    this.statusCode,
    this.reasonPhrase,
  });

  final String? body;
  final Uint8List? bodyBytes;
  final String? reasonPhrase;
  final int? statusCode;
  final Uri? uri;
}
