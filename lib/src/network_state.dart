/// Enum representing the various states of the network.
///
/// This enum defines the possible states of the network, such as when the
/// network is normal, under maintenance, offline, or when the user is not
/// logged in or has just logged in again.
///
/// - [normal]: Represents the network being in a functional state with no issues.
/// - [underMaintenance]: Represents the network being in maintenance and temporarily unavailable.
/// - [offline]: Represents the network being disconnected or unavailable.
/// - [notLoggedIn]: Represents the state when the user is not logged in to the system.
/// - [reLogged]: Represents the state when the user has logged in again after a session expiration or similar event.
enum NetworkState {
  normal,
  underMaintenance,
  offline,
  notLoggedIn,
  reLogged,
  ;

  /// Resolves a value based on the current network state by providing
  /// different functions to handle each possible state.
  ///
  /// This method allows you to provide custom logic for each network state
  /// by passing in functions for each state. The method will call the
  /// appropriate function based on the current state of the network.
  T resolve<T>({
    required T Function() onUnderMaintenance,
    required T Function() onOffline,
    required T Function() onNotLoggedIn,
    required T Function() onNormal,
    required T Function() onReLogged,
  }) {
    return switch (this) {
      NetworkState.underMaintenance => onUnderMaintenance(),
      NetworkState.offline => onOffline(),
      NetworkState.notLoggedIn => onNotLoggedIn(),
      NetworkState.normal => onNormal(),
      NetworkState.reLogged => onReLogged(),
    };
  }
}
