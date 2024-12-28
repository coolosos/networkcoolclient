part of 'base_client.dart';

abstract base class SessionClient extends HttpClient {
  SessionClient({
    required super.key,
    required super.client,
    super.timeout = 30,
    super.defaultHeaders,
  });

  String? _cookie;
  final _mutex = Mutex();

  void _saveCookies(Response response) {
    final setCookies = response.headers[HttpHeaders.setCookieHeader];
    if (setCookies?.isNotEmpty ?? false) {
      _cookie = setCookies;
    }
  }

  Future<String?> getBearerToken();

  Future<bool> renewSesion();

  bool checkIfFailedForInvalidSesion(Response response) {
    return response.statusCode == HttpStatus.unauthorized;
  }

  Future<Map<String, String>> sessionHeaders(
    Map<String, String>? headers,
  ) async {
    headers = Map.of(headers ?? {});

    String? bearerToken = await getBearerToken();
    if (bearerToken?.isEmpty ?? true) {
      await _renewSession(); //! throw NotLoggedInException
      bearerToken = await getBearerToken();
    }
    if (bearerToken?.isNotEmpty ?? false) {
      headers.putIfAbsent(
        HttpHeaders.authorizationHeader,
        () => 'Bearer $bearerToken',
      );
    }

    if (_cookie?.isNotEmpty ?? false) {
      headers.putIfAbsent(
        HttpHeaders.cookieHeader,
        () => _cookie ?? '',
      );
    }
    return headers;
  }

  @override
  Future<Response> executeRequest({
    required Map<String, String>? headers,
    required Future<Response> Function(Map<String, String> headers) send,
  }) async {
    final head = await sessionHeaders(headers);
    Response response = await super.executeRequest(headers: head, send: send);

    final invalidSession = checkIfFailedForInvalidSesion(response);
    if (invalidSession) {
      await _renewSession(); //! throw NotLoggedInException
      final headWithNewSession = await sessionHeaders(headers);
      response = await super.executeRequest(
        headers: headWithNewSession,
        send: send,
      );
    }

    if (_isUnderState(client: this, state: NetworkState.notLoggedIn)) {
      _changeNetworkStatus(
        newState: NetworkState.reLogged,
        client: this,
      );
    }

    _saveCookies(response);

    return response;
  }

  ///! throw NotLoggedInException
  Future<void> _renewSession() async {
    await _mutex.acquire(); //!acquire

    NotLoggedInException? exception;
    // if (_isUnderState(state: NetworkState.RELOGGED, client: this)) {
    //   return;
    // }
    try {
      // final renew = await _mutex.protect<bool>(renewSesion);
      final renew = await renewSesion();
      if (!renew) {
        _changeNetworkStatus(
          newState: NetworkState.notLoggedIn,
          client: this,
        );
        exception = NotLoggedInException();
        _onError(
          error: exception,
          client: this,
        );
      } else {
        _changeNetworkStatus(
          newState: NetworkState.reLogged,
          client: this,
        );
      }
    } finally {
      _mutex.release(); //!release
    }
    if (exception != null) {
      throw exception;
    }
  }

  @override
  bool operator ==(covariant SessionClient other) {
    if (identical(this, other)) return true;

    return other.key == key;
  }

  @override
  int get hashCode => key.hashCode;
}
