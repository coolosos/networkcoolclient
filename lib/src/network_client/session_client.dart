part of 'base_client.dart';

/// Abstract class representing an HTTP client that handles session management,
/// including token renewal and invalid session handling.
abstract base class SessionClient extends HttpClient {
  /// Constructor for initializing the session client with the necessary parameters.
  /// [id] - The identifier for the client, used to track session state.
  /// [client] - The actual HTTP client used to send requests.
  /// [timeout] - The timeout duration for HTTP requests, default is 30 seconds.
  /// [defaultHeaders] - Default headers to be sent with every request.
  SessionClient({
    required super.id,
    required super.client,
    super.timeout = const Duration(seconds: 30),
    super.defaultHeaders,
  });

  /// The cookie received from the server, used for maintaining session.
  String? _cookie;

  /// Mutex used to ensure thread-safe handling of session renewal.
  final _mutex = Mutex();

  /// Saves cookies from the response to maintain session state.
  /// [response] - The HTTP response that may contain cookies.
  void _saveCookies(Response response) {
    // Check if the response contains any cookies in the 'Set-Cookie' header.
    final setCookies = response.headers[HttpHeaders.setCookieHeader];
    if (setCookies?.isNotEmpty ?? false) {
      _cookie = setCookies;
    }
  }

  /// Abstract method to retrieve the bearer token used for authentication.
  /// Returns the bearer token as a string, or null if it is unavailable.
  @protected
  Future<String?> getBearerToken();

  /// Abstract method to renew the session by refreshing the authentication token.
  /// Returns true if the session was successfully renewed, false otherwise.
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
    headers = Map.of(headers ?? {});

    // Attempt to retrieve the bearer token for the session.
    String? bearerToken = await getBearerToken();

    // If no bearer token is available, attempt to renew the session.
    if (bearerToken?.isEmpty ?? true) {
      await _renewSession(); //! Will throw NotLoggedInException if session cannot be renewed
      bearerToken = await getBearerToken();
    }

    // If a bearer token is available, add it to the headers.
    if (bearerToken?.isNotEmpty ?? false) {
      headers.putIfAbsent(
        HttpHeaders.authorizationHeader,
        () => 'Bearer $bearerToken',
      );
    }

    // If a session cookie is available, add it to the headers.
    if (_cookie?.isNotEmpty ?? false) {
      headers.putIfAbsent(
        HttpHeaders.cookieHeader,
        () => _cookie ?? '',
      );
    }

    // Return the prepared headers.
    return headers;
  }

  /// Executes an HTTP request, ensuring session validity and handling token renewal if needed.
  /// [headers] - Custom headers to be included in the request.
  /// [send] - The function that sends the request with the provided headers.
  /// Returns the HTTP response from the request.
  @override
  @protected
  Future<Response> executeRequest({
    required Map<String, String>? headers,
    required Future<Response> Function(Map<String, String> headers) send,
  }) async {
    // Prepare session headers (Authorization and Cookie).
    final head = await sessionHeaders(headers);

    // Attempt to execute the request with the prepared headers.
    Response response = await super.executeRequest(headers: head, send: send);

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
  //! Will throw NotLoggedInException if session renewal fails
  Future<void> _renewSession() async {
    // Acquire the mutex to ensure thread-safe session renewal.
    await _mutex.acquire(); //!acquire

    try {
      // Attempt to renew the session.
      final renewSuccess = await renewSession();

      // If the session cannot be renewed, update the network state and throw an exception.
      if (!renewSuccess) {
        _changeNetworkStatus(
          newState: NetworkState.notLoggedIn,
        );
        final exception = NotLoggedInException();
        _onError(
          error: NotLoggedInException,
        );
        throw exception;
      }

      // If the session was renewed, update the network state.
      _changeNetworkStatus(
        newState: NetworkState.reLogged,
      );
    } finally {
      // Release the mutex once the session renewal attempt is complete.
      _mutex.release(); //!release
    }
  }
}
