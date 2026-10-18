/// Every recoverable error in StreetBite is modelled as a [Failure] so the
/// presentation layer never has to interpret a raw exception.
///
/// The repository / data-source layer converts low level errors (DioException,
/// FirebaseException, PlatformException, ...) into one of these values, and the
/// UI maps [Failure.messageKey] to a localized string. This guarantees the
/// "no unhandled exceptions anywhere" requirement: anything that bubbles out of
/// a Bloc/Cubit is already a friendly, user presentable object.
sealed class Failure implements Exception {
  const Failure(this.messageKey, {this.details});

  /// Key of the localized message to show in the UI (defined in the ARB files).
  final String messageKey;

  /// Optional technical detail used for logging only (never shown to users).
  final String? details;

  @override
  String toString() =>
      '$runtimeType($messageKey${details == null ? '' : ', $details'})';
}

/// Thrown/returned when the remote API cannot be reached or returns garbage.
class ServerFailure extends Failure {
  const ServerFailure({super.details}) : super('failureNetwork');
}

/// Thrown/returned when the local cache could not satisfy the request.
class CacheFailure extends Failure {
  const CacheFailure({super.details}) : super('failureCache');
}

/// Thrown/returned for anything the user can fix by changing their input
/// (wrong password, malformed e-mail, duplicate account, ...).
class ValidationFailure extends Failure {
  const ValidationFailure(super.messageKey, {super.details});
}

/// Thrown/returned when Firebase rejects a credential or an operation.
class AuthFailure extends Failure {
  const AuthFailure(super.messageKey, {super.details});
}

/// Thrown/returned when the user cancelled an action (picker dismissed, ...).
class CancelledFailure extends Failure {
  const CancelledFailure() : super('failureCancelled');
}
