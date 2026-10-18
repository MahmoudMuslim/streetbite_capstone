import 'package:local_auth/local_auth.dart';

/// Service wrapping `local_auth` so every biometric failure is translated into
/// a friendly ARB key exactly once.
///
/// The rest of the app never imports `local_auth`: it asks this service to
/// [authenticate] and receives a `BiometricResult`, which keeps the plugin
/// mockable and stops platform error codes from leaking into widgets.
class BiometricService {
  BiometricService({LocalAuthentication? auth})
    : _auth = auth ?? LocalAuthentication();

  final LocalAuthentication _auth;

  /// Can the device do a biometric check *right now*?
  ///
  /// Returns `false` for "no hardware", "nothing enrolled" and "temporarily
  /// locked out" — the caller decides how to present that.
  ///
  /// The enrolled check is the important one. `canCheckBiometrics` answers "is
  /// this device *capable* of biometrics?", which stays true on a handset with a
  /// fingerprint sensor that the owner never enrolled a finger on. Treating that
  /// as available offered the user a prompt that could never succeed.
  Future<bool> isAvailable() async {
    try {
      if (!await _auth.isDeviceSupported()) return false;
      if (!await _auth.canCheckBiometrics) return false;
      return (await _auth.getAvailableBiometrics()).isNotEmpty;
    } catch (_) {
      // Any platform hiccup is treated as "unavailable" rather than a crash.
      return false;
    }
  }

  /// Prompts for a fingerprint / face scan.
  ///
  /// Returns the localized *key* describing the outcome so the caller decides
  /// how to surface it (dialog, SnackBar, silent navigation).
  Future<BiometricResult> authenticate({required String reason}) async {
    try {
      if (!await _auth.isDeviceSupported()) {
        return const BiometricResult.unavailable();
      }
      if (!await _auth.canCheckBiometrics) {
        return const BiometricResult.unavailable();
      }
      if ((await _auth.getAvailableBiometrics()).isEmpty) {
        // Hardware exists but the owner enrolled nothing, so prompting can only
        // ever fail. Say so precisely instead of telling them to "try again".
        return const BiometricResult.notEnrolled();
      }

      // `local_auth` 3.x passes the flags directly to `authenticate` instead
      // of bundling them in an `AuthenticationOptions` object.
      //
      // `biometricOnly: false` keeps a device with no fingerprint sensor
      // unlockable with its PIN. `persistAcrossBackgrounding: true` retries
      // instead of failing when the user backgrounds the app mid-scan.
      //
      // There is no `useErrorDialogs` any more: the plugin no longer paints
      // native error dialogs, so every failure mode is classified below and
      // surfaced through our own ARB-backed UI. That is a strict improvement —
      // the platform's English-only dialog cannot be localized, ours can.
      final ok = await _auth.authenticate(
        localizedReason: reason,
        biometricOnly: false,
        persistAcrossBackgrounding: true,
      );
      return ok ? BiometricResult.success : const BiometricResult.failure();
    } on LocalAuthException catch (error) {
      return _classify(error.code);
    } on Exception {
      // Anything the plugin does not model is still a handled failure, never an
      // unhandled exception in a widget.
      return const BiometricResult.failure();
    }
  }

  /// Maps a structured `local_auth` failure code onto the app's own outcome.
  ///
  /// `local_auth` 3.0 replaced `PlatformException` with [LocalAuthException],
  /// which carries a [LocalAuthExceptionCode]. Matching on that enum is what
  /// makes the mapping exact — the previous implementation substring-matched
  /// `error.toString()`, so a renamed platform code silently degraded to the
  /// generic "try again" message instead of telling the user to enroll a
  /// fingerprint or wait out a lockout.
  ///
  /// The `switch` is deliberately non-exhaustive with a `default`: the plugin
  /// documents that new codes may be added without a major version bump.
  BiometricResult _classify(LocalAuthExceptionCode code) {
    switch (code) {
      case LocalAuthExceptionCode.noBiometricHardware:
      case LocalAuthExceptionCode.biometricHardwareTemporarilyUnavailable:
        return const BiometricResult.unavailable();

      case LocalAuthExceptionCode.noCredentialsSet:
      case LocalAuthExceptionCode.noBiometricsEnrolled:
        return const BiometricResult.notEnrolled();

      case LocalAuthExceptionCode.temporaryLockout:
      case LocalAuthExceptionCode.biometricLockout:
        return const BiometricResult.lockedOut();

      case LocalAuthExceptionCode.userCanceled:
      case LocalAuthExceptionCode.systemCanceled:
      case LocalAuthExceptionCode.timeout:
        return const BiometricResult.cancelled();

      default:
        // `authInProgress`, `uiUnavailable`, `deviceError`, `unknownError` and
        // any code added in a future release.
        return const BiometricResult.failure();
    }
  }
}

/// Outcome of a biometric prompt, expressed as localization keys.
class BiometricResult {
  const BiometricResult._(this.isSuccess, this.messageKey);

  final bool isSuccess;

  /// ARB key, or `null` on success.
  final String? messageKey;

  static const BiometricResult success = BiometricResult._(true, null);

  const BiometricResult.failure() : this._(false, 'biometricFailed');

  const BiometricResult.cancelled() : this._(false, 'biometricCancelled');

  const BiometricResult.unavailable() : this._(false, 'biometricNotSupported');

  /// The hardware is fine, the owner simply never enrolled a finger or face.
  ///
  /// Distinct from [unavailable] because the remedy is different: this one
  /// cannot be fixed by retrying, it needs Settings.
  const BiometricResult.notEnrolled() : this._(false, 'biometricNotEnrolled');

  /// Too many failed attempts; the sensor is temporarily unusable.
  const BiometricResult.lockedOut() : this._(false, 'biometricLockedOut');
}
