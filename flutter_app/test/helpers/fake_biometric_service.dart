import 'package:streetbite_capstone/data/services/biometric_service.dart';

/// Stand-in for [BiometricService] used by widget tests.
///
/// `local_auth` talks to a platform channel that does not exist in the test
/// runner, so a real instance would hang the test. Registering this stub in
/// GetIt keeps the widget under test completely realistic while staying
/// hermetic.
class FakeBiometricService implements BiometricService {
  FakeBiometricService({
    this.available = false,
    this.result = BiometricResult.success,
  });

  /// Whether the fake device reports usable biometrics.
  bool available;

  /// What [authenticate] returns.
  BiometricResult result;

  @override
  Future<bool> isAvailable() async => available;

  @override
  Future<BiometricResult> authenticate({required String reason}) async =>
      result;
}
