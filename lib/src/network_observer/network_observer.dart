import '../network_client/base_client.dart';
import 'on_response.dart';
import '../network_state.dart';

/// An abstract interface that defines the methods for observing network events
/// and responses in the context of a `BaseClient`. Implementing this interface
/// allows the observer to receive notifications about changes in network status,
/// errors, and responses.
abstract interface class NetworkObserver {
  /// Notifies the observer about a change in the network status.
  ///
  /// This method is triggered when the network status changes, such as when
  /// the client goes offline or comes back online.
  ///
  /// - [client]: The `BaseClient` that initiated the network request.
  /// - [previousState]: The network state before the change occurred.
  /// - [currentState]: The new network state after the change.
  void onChangeNetworkStatus({
    required BaseClient client,
    required NetworkState previousState,
    required NetworkState currentState,
  });

  /// Notifies the observer when an error occurs during a network request.
  ///
  /// This method is triggered when an error happens while making a request,
  /// such as a network failure or a client-side error.
  ///
  /// - [client]: The `BaseClient` that was responsible for the network request.
  /// - [error]: The error object that was thrown during the request.
  /// - [stackTrace]: The stack trace associated with the error (if available).
  void onError({
    required BaseClient client,
    required Object error,
    required StackTrace? stackTrace,
  });

  /// Notifies the observer when a network response has been received.
  ///
  /// This method is triggered when a response is received from the server.
  /// It provides details about the response such as the status code, body, etc.
  ///
  /// - [client]: The `BaseClient` that made the request.
  /// - [response]: The response data received from the server, encapsulated
  ///   in the `OnResponse` object.
  void onResponse({
    required BaseClient client,
    required OnResponse response,
  });

  /// Dispose of resources when the observer is no longer needed.
  ///
  /// This method is used to clean up any resources or listeners associated
  /// with the observer when it is no longer required or is being destroyed.
  void dispose();
}
