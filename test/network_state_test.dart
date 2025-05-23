import 'package:network_cool_client/network_cool_client.dart';
import 'package:test/test.dart';

void main() {
  group(
    'Network state',
    () {
      test(
        'resolve',
        () {
          for (var element in NetworkState.values) {
            final resolve = element.resolve<NetworkState>(
              onUnderMaintenance: () {
                return NetworkState.underMaintenance;
              },
              onOffline: () {
                return NetworkState.offline;
              },
              onNotLoggedIn: () {
                return NetworkState.notLoggedIn;
              },
              onNormal: () {
                return NetworkState.normal;
              },
              onReLogged: () {
                return NetworkState.reLogged;
              },
            );
            expect(element, resolve);
          }
        },
      );
    },
  );
}
