


import 'package:network_cool_client/src/network_client/base_client.dart';
import 'package:network_cool_client/src/network_observer/on_response.dart';
import 'package:network_cool_client/src/network_state.dart';

abstract interface class NetworkObserver {
  void onChangeNetworkStatus({
    required BaseClient client,
    required NetworkState previousState,
    required NetworkState currentState,
  });

  void onError({
    required BaseClient client,
    required Object error,
    required StackTrace? stackTrace,
  });

  void onResponse({
    required BaseClient client,
    required OnResponse response,
  });
}
