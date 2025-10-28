import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:ncc/ncc.dart';
import 'package:test/fake.dart';

base class MockClient extends Fake implements Client {
  @mustBeOverridden
  Future<Response> get genericResponse;

  @override
  Future<Response> get(Uri url, {Map<String, String>? headers}) =>
      genericResponse;

  @override
  Future<Response> patch(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) =>
      genericResponse;

  @override
  Future<Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) =>
      genericResponse;

  @override
  Future<Response> delete(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) =>
      genericResponse;

  @override
  Future<Response> head(Uri url, {Map<String, String>? headers}) =>
      genericResponse;

  @override
  Future<Response> put(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) =>
      genericResponse;
}
