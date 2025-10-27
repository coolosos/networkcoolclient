part of 'base_client.dart';

/// Mixin that observes network state changes and allows notifying observers
/// when the network status or response changes.
///
/// This mixin manages a list of observers that will be notified about changes
/// in network state, such as when the client goes offline or comes back online.
/// It also provides hooks to respond to HTTP responses and errors.
mixin NetworkObservable on BaseClient {
  /// A set of observers that will be notified about network state changes.
  Set<NetworkObserver> get _localNetworkObservers;

  /// Returns a combined set of network observers.
  ///
  /// This includes both the local observers specific to the client instance
  /// and the global observers registered through [GlobalNetworkObservable].
  /// Duplicates are automatically handled since sets do not allow them.
  Set<NetworkObserver> get _observers =>
      {..._localNetworkObservers, ...GlobalNetworkObservable.observers};

  ///Determinate if the [BaseClient] contains any local observer
  bool get isObservable => _localNetworkObservers.isNotEmpty;

  ///Determinate if the [BaseClient] contains any observer
  bool get isGlobalObservable => _observers.isNotEmpty;

  /// Adds a new observer to be notified about network status changes.
  ///
  /// Returns `true` if the observer was added successfully, `false` if it was already present.
  bool addObserver(NetworkObserver observer) {
    return _localNetworkObservers.add(observer);
  }

  /// Removes an existing observer.
  ///
  /// Returns `true` if the observer was removed, `false` if the observer was not found.
  bool removeObserver(NetworkObserver observer) {
    return _localNetworkObservers.remove(observer);
  }

  /// Checks whether the current client is in a specific network state.
  ///
  /// This method returns `true` if the client is in the given state, otherwise `false`.
  @protected
  bool _isUnderState({
    required NetworkState state,
  }) {
    return clientState == state;
  }

  /// Changes the network state for the given client and notifies all observers
  /// about the state change if it differs from the previous state.
  ///
  /// This method will only notify observers if the state has changed, and it will
  /// prevent unnecessary notifications if the client is already in the new state.
  @protected
  void _changeNetworkStatus({
    required NetworkState newState,
  }) {
    final previousState = clientState;

    // Check if a re-login is needed or if the state is actually unchanged.
    final isActuallyReLogin = _isActuallyReLogin(previousState, newState);
    if (newState == previousState || isActuallyReLogin) {
      return;
    }

    // Notify all observers about the network status change.
    for (final observer in _observers) {
      observer.onChangeNetworkStatus(
        client: this,
        previousState: previousState,
        currentState: newState,
      );
    }

    // Update the network state.
    setClientState(newState);
  }

  /// Determines if the previous state indicates the client needs a re-login.
  ///
  /// This helper method checks whether the previous state was `notLoggedIn` and
  /// if the new state is not `reLogged`, which might indicate a need for a re-login.
  @protected
  bool _isActuallyReLogin(NetworkState previousState, NetworkState newState) {
    return previousState == NetworkState.notLoggedIn &&
        newState != NetworkState.reLogged;
  }

  /// Handles HTTP response by notifying observers about the response details.
  ///
  /// This method is called when an HTTP response is received. It creates a detailed
  /// `OnResponse` object and notifies all observers about the response.
  @protected
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
    for (final observer in _observers) {
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
  @protected
  void _onError({
    required Object error,
    StackTrace? stackTrace,
  }) {
    // Notify all observers about the error that occurred.
    for (final observer in _observers) {
      observer.onError(
        error: error,
        stackTrace: stackTrace,
        client: this,
      );
    }
  }

  /// Retrieves the network state of the client.
  ///
  /// This helper method checks if a state is available for the client in `_networkState`.
  /// If no state is found, it returns the default `NetworkState.normal`.
  NetworkState get clientState {
    return GlobalNetworkObservable.getClientState(this);
  }

  /// Sets the network state for the client.
  ///
  /// This helper method updates the network state for the client in `_networkState`.
  void setClientState(NetworkState state) {
    GlobalNetworkObservable.setClientState(this, state);
  }

  /// Disposes all local observers registered to this client.
  ///
  /// This does not affect global observers registered in [GlobalNetworkObservable].
  @mustCallSuper
  void dispose() {
    for (final observer in _localNetworkObservers) {
      observer.dispose();
    }
    _localNetworkObservers.clear();
  }
}

/// Manages global network observers and tracks network state per client.
///
/// This class allows clients to share and report network-related events
/// through a common observer mechanism. It also maintains the latest known
/// network state for each client by ID.
final class GlobalNetworkObservable {
  /// A set of global [NetworkObserver]s that will be notified about
  /// network state changes, responses, and errors from any registered client.
  static final Set<NetworkObserver> _observers = {};

  /// A set of global [NetworkObserver]s that will be notified about.
  static Set<NetworkObserver> get observers => _observers;

  /// Adds a new observer to be notified about network status changes.
  ///
  /// Returns `true` if the observer was added successfully, `false` if it was already present.
  static bool addObserver(NetworkObserver observer) {
    return _observers.add(observer);
  }

  /// Removes an existing observer.
  ///
  /// Returns `true` if the observer was removed, `false` if the observer was not found.
  static bool removeObserver(NetworkObserver observer) {
    return _observers.remove(observer);
  }

  /// Disposes all registered global observers and clears the observer set.
  ///
  /// This method should be called when global observation is no longer needed,
  /// such as during application shutdown or test teardown.
  static void dispose() {
    for (final observer in _observers) {
      observer.dispose();
    }
    _observers.clear();
  }

  /// Holds the current [NetworkState] for each [BaseClient] by its `id`.
  ///
  /// This map allows tracking individual client network state globally.
  static final Map<String, NetworkState> _networkState = {};

  /// Returns the current [NetworkState] for the given [client].
  ///
  /// If no state is registered for the client, it defaults to [NetworkState.normal].
  static NetworkState getClientState(BaseClient client) {
    return _networkState[client.id] ?? NetworkState.normal;
  }

  /// Sets the [NetworkState] for the specified [client].
  ///
  /// This updates the internal state map to reflect the latest state of the client.
  static void setClientState(BaseClient client, NetworkState state) {
    _networkState[client.id] = state;
  }
}
