import '../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

/// Parameters for [SetBiometricSignIn].
class SetBiometricSignInParams extends Params {
  const SetBiometricSignInParams({required this.enabled});

  final bool enabled;

  @override
  List<Object?> get props => [enabled];
}

/// Turns the biometric gate on a restored session on or off for this device.
class SetBiometricSignIn implements UseCase<void, SetBiometricSignInParams> {
  const SetBiometricSignIn(this._repository);

  final AuthRepository _repository;

  @override
  Future<void> call(SetBiometricSignInParams params) =>
      _repository.setBiometricSignInEnabled(enabled: params.enabled);
}
