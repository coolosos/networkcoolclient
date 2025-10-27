part of 'base_client.dart';

class _ConcurrencyManager {
  final _renewalFutures = <String, Future<void>>{};

  Future<void> execute(String id, Future<void> Function() renewFn) {
    if (_renewalFutures[id] case final renewal?) {
      return renewal;
    }

    final renewalFuture = renewFn();
    _renewalFutures[id] = renewalFuture;

    return renewalFuture.whenComplete(() {
      _renewalFutures.remove(id);
    });
  }

  Future<void> awaitRenewal(String id) {
    if (_renewalFutures[id] case final renewal?) {
      return renewal;
    }
    return Future.value();
  }
}

/// Abstract class representing an HTTP client that handles session management,
/// including token renewal and invalid session handling.
@immutable
abstract base class SessionClient extends NccClient {
  /// Constructor for initializing the session client with the necessary parameters.
  /// [id] - The identifier for the client, used to track session state.
  /// [client] - The actual HTTP client used to send requests.
  /// [timeout] - The timeout duration for HTTP requests, default is 30 seconds.
  /// [defaultHeaders] - Default headers to be sent with every request.
  /// [observers] - Observers that listener every request.
  /// [sessionStateManager] - The manager for handling session state, such as cookies.
  SessionClient({
    required super.id,
    required super.client,
    super.timeout = const Duration(seconds: 30),
    super.defaultHeaders,
    super.observers,
    SessionStateManager? sessionStateManager,
  }) : _sessionStateManager =
            sessionStateManager ?? InMemorySessionStateManager();
  static final _concurrencyManager = _ConcurrencyManager();

  final SessionStateManager _sessionStateManager;

  /// Saves cookies from the response to maintain session state.
  /// [response] - The HTTP response that may contain cookies.
  void _saveCookies(Response response) {
    // Check if the response contains any cookies in the 'Set-Cookie' header.
    final setCookies = response.headers[HttpHeaders.setCookieHeader];
    if (setCookies?.isNotEmpty ?? false) {
      _sessionStateManager.setCookie(id, setCookies);
    }
  }

  /// Abstract method to retrieve the bearer token used for authentication.
  /// Returns the bearer token as a string, or null if it is unavailable.
  @protected
  Future<String?> getBearerToken();

  /// Attempts to renew the session by refreshing the authentication token.
  ///
  /// Returns `true` if the session was successfully renewed, allowing the original
  /// request to be retried. Returns `false` if the renewal failed, typically indicating
  /// that the user is no longer authenticated.
  @protected
  Future<bool> renewSession();

  /// Checks if the response indicates an invalid session (unauthorized).
  /// [response] - The HTTP response to check.
  /// Returns true if the response status code is 401 (Unauthorized), indicating the session is invalid.
  @protected
  bool checkIfFailedForInvalidSession(Response response) {
    return response.statusCode == HttpStatus.unauthorized;
  }

  /// Prepares the headers for a request, ensuring they include valid session tokens and cookies.
  /// [headers] - Custom headers to be included in the request.
  /// Returns a map of headers, including any session-related headers (Authorization and Cookie).
  @protected
  @visibleForTesting
  Future<Map<String, String>> sessionHeaders(
    Map<String, String>? headers,
  ) async {
    // Start with a copy of the provided headers or an empty map if null.
    final finalHeaders = Map<String, String>.of(headers ?? {});

    // Attempt to retrieve the bearer token for the session.
    var bearerToken = await getBearerToken();

    // If no bearer token is available, attempt to renew the session.
    if (bearerToken?.isEmpty ?? true) {
      await _renewSession(); //! Will throw NotLoggedInException if session cannot be renewed
      bearerToken = await getBearerToken();
    }

    // If a bearer token is available, add it to the headers.
    if (bearerToken?.isNotEmpty ?? false) {
      finalHeaders.putIfAbsent(
        HttpHeaders.authorizationHeader,
        () => 'Bearer $bearerToken',
      );
    }

    final cookie = _sessionStateManager.getCookie(id);

    // If a session cookie is available, add it to the headers.
    if (cookie?.isNotEmpty ?? false) {
      finalHeaders.putIfAbsent(
        HttpHeaders.cookieHeader,
        () => cookie ?? '',
      );
    }

    // Return the prepared headers.
    return finalHeaders;
  }

  /// Executes an HTTP request, ensuring session validity and handling token renewal if needed.
  /// [headers] - Custom headers to be included in the request.
  /// [send] - The function that sends the request with the provided headers.
  /// Returns the HTTP response from the request.
  @override
  @protected
  Future<Response> executeRequest({
    required Map<String, String> headers,
    required Future<Response> Function(Map<String, String> headers) send,
  }) async {
    // If a renewal is in progress, wait for it to finish before doing anything.
    await _concurrencyManager.awaitRenewal(id);

    // Prepare session headers (Authorization and Cookie).
    final head = await sessionHeaders(headers);

    // Attempt to execute the request with the prepared headers.
    var response = await super.executeRequest(headers: head, send: send);

    // If the session is invalid, attempt to renew the session.
    if (checkIfFailedForInvalidSession(response)) {
      await _renewSession(); //! Will throw NotLoggedInException if session cannot be renewed
      final headWithNewSession = await sessionHeaders(headers);
      response = await super.executeRequest(
        headers: headWithNewSession,
        send: send,
      );
    }

    // If the session was re-established, update the network state.
    if (_isUnderState(state: NetworkState.notLoggedIn)) {
      _changeNetworkStatus(
        newState: NetworkState.reLogged,
      );
    }

    // Save the cookies from the response (for session persistence).
    _saveCookies(response);

    // Return the final response.
    return response;
  }

  /// Renews the session by refreshing the token and updating network status.
  /// This function is called when the session has expired and needs to be renewed.
  /// Throws [NotLoggedInException] if session renewal fails.
  Future<void> _renewSession() {
    return _concurrencyManager.execute(id, () async {
      final renewSuccess = await renewSession();

      if (!renewSuccess) {
        _changeNetworkStatus(
          newState: NetworkState.notLoggedIn,
        );
        final exception = NotLoggedInException();
        _onError(
          error: exception,
        );
        throw exception;
      }

      _changeNetworkStatus(
        newState: NetworkState.reLogged,
      );
    });
  }
}
