/// Abstract class for managing the state of a session, such as cookies.
///
/// This class can be extended to provide custom storage mechanisms for session
/// data, such as databases, shared preferences, or web cookies.
abstract base class SessionStateManager {
  const SessionStateManager();

  /// Retrieves the cookie for a given client ID.
  String? getCookie(String clientId);

  /// Sets the cookie for a given client ID.
  void setCookie(String clientId, String? cookie);
}

/// An in-memory implementation of [SessionStateManager].
///
/// This class stores session cookies in a map in memory. The state is lost
/// when the application is terminated.
final class InMemorySessionStateManager implements SessionStateManager {
  InMemorySessionStateManager();

  final _cookies = <String, String?>{};

  @override
  String? getCookie(String clientId) => _cookies[clientId];

  @override
  void setCookie(String clientId, String? cookie) {
    _cookies[clientId] = cookie;
  }
}
