import 'package:network_cool_client/src/network_client/session_state_manager.dart';
import 'package:test/test.dart';

final class _TestSessionStateManager extends SessionStateManager {
  const _TestSessionStateManager();

  @override
  String? getCookie(String clientId) => null;

  @override
  void setCookie(String clientId, String? cookie) {}
}

void main() {
  group('SessionStateManager', () {
    test('should be able to be constructed', () {
      // Arrange
      const manager = _TestSessionStateManager();

      // Assert
      expect(manager, isNotNull);
    });
  });
  group('InMemorySessionStateManager', () {
    test('should store and retrieve a cookie', () {
      // Arrange
      const clientId = 'test_client';
      const cookie = 'test_cookie';
      final manager = InMemorySessionStateManager()
        ..setCookie(clientId, cookie);
      final retrievedCookie = manager.getCookie(clientId);

      // Assert
      expect(retrievedCookie, cookie);
    });

    test('should return null for a non-existent cookie', () {
      // Arrange
      const clientId = 'non_existent_client';
      final manager = InMemorySessionStateManager();

      // Act
      final retrievedCookie = manager.getCookie(clientId);

      // Assert
      expect(retrievedCookie, isNull);
    });

    test('should overwrite an existing cookie', () {
      // Arrange
      const clientId = 'test_client';
      const oldCookie = 'old_cookie';
      const newCookie = 'new_cookie';
      final manager = InMemorySessionStateManager()
        ..setCookie(clientId, oldCookie)
        ..setCookie(clientId, newCookie);
      final retrievedCookie = manager.getCookie(clientId);

      // Assert
      expect(retrievedCookie, newCookie);
    });
  });
}
