part of 'base_client.dart';

base mixin NetworkObservable on BaseClient {
  final Set<NetworkObserver> _observers = {};

  // NetworkState _networkState = NetworkState.normal;
  static final Map<String, NetworkState> networkState = Map.of({});
  bool addObserver(NetworkObserver observer) {
    return _observers.add(observer);
  }

  bool removeObserver(NetworkObserver observer) {
    return _observers.remove(observer);
  }

  bool _isUnderState({
    required NetworkState state,
    required BaseClient client,
  }) {
    return (networkState[client.key] ?? NetworkState.normal) == state;
  }

  void _changeNetworkStatus({
    required NetworkState newState,
    required BaseClient client,
  }) {
    final previousState = networkState[client.key] ?? NetworkState.normal;

    final isActuallyReLogin = (previousState == NetworkState.notLoggedIn &&
        newState != NetworkState.reLogged);

    if ((newState == previousState || isActuallyReLogin)) {
      return;
    }

    for (var observer in _observers) {
      observer.onChangeNetworkStatus(
        client: client,
        previousState: previousState,
        currentState: newState,
      );
    }
    networkState[client.key] = newState;
  }

  void _onResponse({
    required Response response,
    required BaseClient client,
  }) {
    final OnResponse onResponse = OnResponse(
      uri: response.request?.url,
      statusCode: response.statusCode,
      body: response.body,
      bodyBytes: response.bodyBytes,
      reasonPhrase: response.reasonPhrase,
    );
    for (var observer in _observers) {
      observer.onResponse(
        response: onResponse,
        client: client,
      );
    }
  }

  void _onError({
    required Object error,
    required BaseClient client,
    StackTrace? stackTrace,
  }) {
    for (var observer in _observers) {
      observer.onError(
        error: error,
        stackTrace: stackTrace,
        client: client,
      );
    }
  }
}
