enum NetworkState {
  normal,
  underMaintenance,
  offline,
  notLoggedIn,
  reLogged,
  ;

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
