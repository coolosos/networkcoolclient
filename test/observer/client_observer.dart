import 'package:ncc/network_cool_client.dart';

final class ClientObserver implements NetworkObserver {
  ClientObserver();
  final List<ClientObserverAction> callingActions = [];
  @override
  void dispose() {
    callingActions.add(ClientObserverAction.onDispose);
  }

  @override
  void onChangeNetworkStatus({
    required BaseClient client,
    required NetworkState previousState,
    required NetworkState currentState,
  }) {
    callingActions.add(ClientObserverAction.onChangeNetworkStatus);
  }

  @override
  void onError({
    required BaseClient client,
    required Object error,
    required StackTrace? stackTrace,
  }) {
    callingActions.add(ClientObserverAction.onError);
  }

  @override
  void onResponse({required BaseClient client, required OnResponse response}) {
    callingActions.add(ClientObserverAction.onResponse);
  }
}

enum ClientObserverAction {
  onDispose,
  onChangeNetworkStatus,
  onError,
  onResponse,
}
