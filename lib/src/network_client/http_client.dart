part of 'base_client.dart';


base class HttpClient extends BaseClient with NetworkObservable {
  HttpClient({
    required super.client,
    required super.key,
    this.timeout = 30,
    this.defaultHeaders,
  });

  final int timeout;
  final Map<String, String>? defaultHeaders;

  Map<String, String> initializeHeaders(
    Map<String, String>? customRequestHeaders,
  ) {
    final Map<String, String> headers = Map.of(
      customRequestHeaders ??
          {
            // "Access-Control-Allow-Origin": "*",  Se supone que deshabilitaría los cors
            // 'Content-Type': 'application/json',
            // 'Accept': '*/*',
          },
    );

    defaultHeaders?.forEach((key, value) {
      headers.putIfAbsent(
        key,
        () => value,
      );
    });
    return headers;
  }

  bool checkUnderMaintenance(Response response) {
    return response.statusCode == HttpStatus.serviceUnavailable;
  }

  @override
  Future<Response> executeRequest({
    required Map<String, String>? headers,
    required Future<Response> Function(Map<String, String> headers) send,
  }) async {
    try {
      final response = await send.call(initializeHeaders(headers)).timeout(
            Duration(seconds: timeout),
          );
      _onResponse(
        response: response,
        client: this,
      );

      if (checkUnderMaintenance(response)) {
        _changeNetworkStatus(
          newState: NetworkState.underMaintenance,
          client: this,
        );
        final exception = ServerAvailabilityException();
        _onError(
          error: exception,
          client: this,
        );
        throw exception;
      }
      //normalize status

      _changeNetworkStatus(
        newState: NetworkState.normal,
        client: this,
      );

      return response;
    } on SocketException catch (error, stackTrace) {
      _changeNetworkStatus(
        newState: NetworkState.offline,
        client: this,
      );
      _onError(
        error: error,
        stackTrace: stackTrace,
        client: this,
      );

      throw NetworkAvailabilityException();
    } on ClientException catch (error, stackTrace) {
      // if (error.message != 'XMLHttpRequest error.') {
      _changeNetworkStatus(
        newState: NetworkState.offline,
        client: this,
      );
      // }
      _onError(
        error: error,
        stackTrace: stackTrace,
        client: this,
      );
      throw NetworkAvailabilityException();
    } on TimeoutException catch (error, stackTrace) {
      _onError(
        error: error,
        stackTrace: stackTrace,
        client: this,
      );
      rethrow;
    } catch (error, stackTrace) {
      _onError(
        error: error,
        stackTrace: stackTrace,
        client: this,
      );
      rethrow;
    }
  }
}
