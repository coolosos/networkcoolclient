part of 'base_client.dart';

/// Mixin that observes network state changes and allows notifying observers
/// when the network status or response changes.
///
/// This mixin manages a list of observers that will be notified about changes
/// in network state, such as when the client goes offline or comes back online.
/// It also provides hooks to respond to HTTP responses and errors.
mixin NetworkObservable on BaseClient {
  /// A set of observers that will be notified about network state changes.
  static final Set<NetworkObserver> _observers = {};

  /// A static map that holds the network state for each client identified by `client.id`.
  static final Map<String, NetworkState> _networkState = {};

  /// Adds a new observer to be notified about network status changes.
  ///
  /// Returns `true` if the observer was added successfully, `false` if it was already present.
  bool addObserver(NetworkObserver observer) {
    return _observers.add(observer);
  }

  /// Removes an existing observer.
  ///
  /// Returns `true` if the observer was removed, `false` if the observer was not found.
  bool removeObserver(NetworkObserver observer) {
    return _observers.remove(observer);
  }

  /// Checks whether the current client is in a specific network state.
  ///
  /// This method returns `true` if the client is in the given state, otherwise `false`.
  bool _isUnderState({
    required NetworkState state,
  }) {
    return getClientState(this) == state;
  }

  /// Changes the network state for the given client and notifies all observers
  /// about the state change if it differs from the previous state.
  ///
  /// This method will only notify observers if the state has changed, and it will
  /// prevent unnecessary notifications if the client is already in the new state.
  void _changeNetworkStatus({
    required NetworkState newState,
  }) {
    final previousState = getClientState(this);

    // Check if a re-login is needed or if the state is actually unchanged.
    final isActuallyReLogin = _isActuallyReLogin(previousState, newState);
    if ((newState == previousState || isActuallyReLogin)) {
      return;
    }

    // Notify all observers about the network status change.
    for (var observer in _observers) {
      observer.onChangeNetworkStatus(
        client: this,
        previousState: previousState,
        currentState: newState,
      );
    }

    // Update the network state.
    setClientState(this, newState);
  }

  /// Determines if the previous state indicates the client needs a re-login.
  ///
  /// This helper method checks whether the previous state was `notLoggedIn` and
  /// if the new state is not `reLogged`, which might indicate a need for a re-login.
  bool _isActuallyReLogin(NetworkState previousState, NetworkState newState) {
    return previousState == NetworkState.notLoggedIn &&
        newState != NetworkState.reLogged;
  }

  /// Handles HTTP response by notifying observers about the response details.
  ///
  /// This method is called when an HTTP response is received. It creates a detailed
  /// `OnResponse` object and notifies all observers about the response.
  void _onResponse({
    required Response response,
  }) {
    final onResponse = OnResponse(
      uri: response.request?.url,
      statusCode: response.statusCode,
      body: response.body,
      bodyBytes: response.bodyBytes,
      reasonPhrase: response.reasonPhrase,
    );

    // Notify all observers about the received response.
    for (var observer in _observers) {
      observer.onResponse(
        response: onResponse,
        client: this,
      );
    }
  }

  /// Handles errors during the network request by notifying observers.
  ///
  /// This method is called when an error occurs during the network request. It
  /// notifies all observers about the error, passing along the error and stack trace.
  void _onError({
    required Object error,
    StackTrace? stackTrace,
  }) {
    // Notify all observers about the error that occurred.
    for (var observer in _observers) {
      observer.onError(
        error: error,
        stackTrace: stackTrace,
        client: this,
      );
    }
  }

  /// Retrieves the network state of the given client.
  ///
  /// This helper method checks if a state is available for the client in `_networkState`.
  /// If no state is found, it returns the default `NetworkState.normal`.
  NetworkState getClientState(BaseClient client) {
    return _networkState[client.id] ?? NetworkState.normal;
  }

  /// Sets the network state for the given client.
  ///
  /// This helper method updates the network state for the client in `_networkState`.
  void setClientState(BaseClient client, NetworkState state) {
    _networkState[client.id] = state;
  }

  /// Disposes all observers by clearing the `_observers` set.
  ///
  /// This is useful for cleanup when the client is no longer needed, such as
  /// when disposing of a service or when a client instance is deactivated.
  void disposeObservers() {
    for (var observer in _observers) {
      observer.dispose();
    }
    _observers.clear();
  }
}
