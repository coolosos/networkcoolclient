import 'package:network_cool_client/network_cool_client.dart';

class CustomNetworkObserver implements NetworkObserver {
  CustomNetworkObserver({
    this.onUndermantenance,
    this.onOffline,
    this.onNotLoggedIn,
  });

  final Future<void> Function()? onUndermantenance;
  final Future<void> Function()? onOffline;
  final Future<void> Function()? onNotLoggedIn;

  @override
  void onChangeNetworkStatus({
    required NetworkState previousState,
    required NetworkState currentState,
    required BaseClient client,
  }) {
    if ((client.runtimeType == HttpClient) || (previousState == currentState)) {
      return;
    }

    currentState.resolve(
      onUnderMaintenance: () {
        if (onUndermantenance case final onUndermantenance?) {
          onUndermantenance();
        }
      },
      onOffline: () {
        if (onOffline case final onOffline?) {
          onOffline();
        }
      },
      onNotLoggedIn: () {
        if (onNotLoggedIn case final onNotLoggedIn?) {
          onNotLoggedIn();
        }
      },
      onNormal: () {},
      onReLogged: () {},
    );
  }

  @override
  void onError({
    required Object error,
    required StackTrace? stackTrace,
    required BaseClient client,
  }) {
    // ignore: avoid_print
    print('Error handle');
  }

  @override
  void onResponse({
    required OnResponse response,
    required BaseClient client,
  }) {
    // ignore: avoid_print
    print(response.body);
  }

  @override
  void dispose() {}
}
