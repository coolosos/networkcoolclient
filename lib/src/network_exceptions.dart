/// A base class for all exceptions related to network errors.
///
/// This is an abstract class that serves as a common superclass for
/// all exceptions related to network connectivity or availability issues.
/// It implements [Exception] to indicate that these are exception types
/// that can be thrown and caught in error-handling code.
sealed class NetworkException implements Exception {}

/// Exception thrown when there is a network availability issue, such as
/// when the device is offline or cannot reach the server.
///
/// This class represents errors that are specifically related to the
/// unavailability of the network. For example, if the device cannot
/// connect to the internet or if there are connection timeout issues.
base class NetworkAvailabilityException implements NetworkException {}

/// Exception thrown when the server is unavailable, typically when the
/// server is down or unreachable.
///
/// This class represents errors that occur when the server cannot
/// process the request, such as in the case of a 503 Service Unavailable
/// HTTP status or when the server is temporarily out of service.
base class ServerAvailabilityException implements NetworkException {}

/// Exception thrown when the user is not logged in or when the session
/// has expired, leading to unauthorized access issues.
///
/// This class is typically used to indicate that the user needs to log
/// in again, as the current session is no longer valid. It can be thrown
/// when an operation requires user authentication but the user is not logged in.
base class NotLoggedInException implements NetworkException {}
