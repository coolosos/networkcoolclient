sealed class NetworkException implements Exception {}

class NetworkAvailabilityException implements NetworkException {}

class ServerAvailabilityException implements NetworkException {}

class NotLoggedInException implements NetworkException {}
