import '../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

/// Reads this device's biometric sign-in opt-in.
///
/// Synchronous on purpose: the answer is a cached `SharedPreferences` bool, and
/// the splash has to branch on it before it can pick a route. Awaiting a
/// `Future` there buys nothing and adds a frame where neither Home nor the
/// biometric prompt has been decided.
class GetBiometricSignIn implements SyncUseCase<bool, NoParams> {
  const GetBiometricSignIn(this._repository);

  final AuthRepository _repository;

  @override
  bool call(NoParams params) => _repository.biometricSignInEnabled;
}
