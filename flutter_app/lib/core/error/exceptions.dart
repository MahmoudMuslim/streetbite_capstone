/// Low level exceptions thrown by the data sources.
///
/// These never escape the data layer: each repository catches them and maps
/// them onto a `Failure` (see `core/error/failures.dart`).
library;

/// Raised by the Dio wrapper for transport / status-code problems.
class NetworkException implements Exception {
  const NetworkException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => 'NetworkException($message, status: $statusCode)';
}

/// Raised when a payload cannot be parsed into the expected model.
class SerializationException implements Exception {
  const SerializationException(this.message);

  final String message;

  @override
  String toString() => 'SerializationException($message)';
}

/// Raised by the Firestore singleton when the SDK is not initialised.
class FirestoreNotAvailableException implements Exception {
  const FirestoreNotAvailableException();

  @override
  String toString() => 'FirestoreNotAvailableException';
}
