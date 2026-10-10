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
  Future<bool> isAvailable() async {
    try {
      if (!await _auth.isDeviceSupported()) return false;
      return await _auth.canCheckBiometrics;
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
      if (!await isAvailable()) {
        return const BiometricResult.unavailable();
      }
      final ok = await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          // Both sticky and biometric are accepted so a device without a
          // fingerprint sensor can still unlock with a PIN.
          biometricOnly: false,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );
      return ok ? BiometricResult.success : const BiometricResult.failure();
    } on Exception catch (error) {
      final code = error.toString();
      if (code.contains('NotAvailable') || code.contains('NotEnrolled')) {
        return const BiometricResult.unavailable();
      }
      if (code.contains('LockedOut') || code.contains('PermanentlyLockedOut')) {
        return const BiometricResult.lockedOut();
      }
      if (code.contains('Canceled') || code.contains('UserCanceled')) {
        return const BiometricResult.cancelled();
      }
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

  const BiometricResult.lockedOut() : this._(false, 'biometricNotEnrolled');
}
