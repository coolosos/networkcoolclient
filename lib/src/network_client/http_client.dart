part of 'base_client.dart';

/// A base HTTP client that integrates network state management and response handling.
///
/// This class is a custom implementation of a network client that supports automatic
/// network state updates (e.g., online, offline, under maintenance) based on the
/// server response. It uses a timeout and manages custom headers in each request.
class HttpClient extends BaseClient with NetworkObservable {
  /// Creates a new [HttpClient] instance.
  ///
  /// [client] is the underlying HTTP client used to send requests.
  /// [id] is a unique identifier for this client instance.
  /// [timeout] specifies the duration to wait for a server response before timing out (default is 30 seconds).
  /// [defaultHeaders] contains headers that will be sent with every request, but can be overridden by custom headers.
  /// [observers] - Observers that listener every request.
  HttpClient({
    required super.client,
    required super.id,
    this.timeout = const Duration(seconds: 30),
    this.defaultHeaders,
    Set<NetworkObserver>? observers,
  }) : _localNetworkObservers = observers ?? {};

  @override
  final Set<NetworkObserver> _localNetworkObservers;

  /// Timeout duration for HTTP requests, defaults to 30 seconds.
  final Duration timeout;

  /// Default headers to be included with each request, can be overridden by custom headers.
  final Map<String, String>? defaultHeaders;

  /// Initializes request headers by combining default headers and custom headers.
  ///
  /// Custom headers are provided by the caller, and default headers (if any) are
  /// merged in. Default headers are only used if the custom headers do not already
  /// specify a value for the same key.
  @override
  Map<String, String> normalizeHeaders(Map<String, String>? headers) {
    final Map<String, String> clientHeaders = Map.of(defaultHeaders ?? {});

    // Override the [defaultHeaders] with the headers send by the execution.
    clientHeaders.addAll(headers ?? {});

    return clientHeaders;
  }

  /// Checks if the server is under maintenance based on the HTTP response status code.
  ///
  /// This method specifically checks for a 503 Service Unavailable status code, which
  /// indicates that the server is temporarily unavailable.
  @override
  @protected
  bool checkUnderMaintenance(Response response) {
    return response.statusCode == HttpStatus.serviceUnavailable;
  }

  /// Executes an HTTP request with error handling and state management.
  ///
  /// [headers] are the headers to include in the request. These headers are merged
  /// with default headers using [initializeHeaders].
  /// [send] is a function that performs the actual HTTP request and returns a [Response].
  ///
  /// This method handles various exceptions, including socket errors, client errors,
  /// and timeout errors. If the request is successful and the server is under maintenance,
  /// the network state will be updated to `underMaintenance`. If the request fails due to
  /// network issues, the state will be set to `offline`. Any errors are passed to observers.
  @override
  @protected
  Future<Response> executeRequest({
    required Map<String, String> headers,
    required Future<Response> Function(Map<String, String> headers) send,
  }) async {
    try {
      // Attempt the request and apply the timeout.
      final response = await send.call(headers).timeout(timeout);

      // Notify observers of the response.
      _onResponse(response: response);

      // If the server is under maintenance, handle it and throw an exception.
      if (checkUnderMaintenance(response)) {
        throw ServerAvailabilityException();
      }

      // Normalize network status.
      _changeNetworkStatus(newState: NetworkState.normal);

      return response;
    } catch (error, stackTrace) {
      // Handle network-related or client-side errors and update the status accordingly.
      _handleErrors(error, stackTrace);
      rethrow;
    }
  }

  /// Handles errors, updating network status and notifying observers.
  void _handleErrors(Object error, StackTrace? stackTrace) {
    NetworkException? exception;
    // Determine the network state based on the error type.
    final isOffline = error is SocketException || error is ClientException;
    if (isOffline) {
      _changeNetworkStatus(newState: NetworkState.offline);
      _onError(
        error: NetworkAvailabilityException(),
        stackTrace: stackTrace,
      );
      exception = NetworkAvailabilityException();
    }

    ///Determine the case when the server is under maintenance.
    if (error is ServerAvailabilityException) {
      _changeNetworkStatus(newState: NetworkState.underMaintenance);
      exception = ServerAvailabilityException();
    }

    _onError(error: error, stackTrace: stackTrace);

    if (exception case final exception?) {
      throw exception;
    }
  }
}
