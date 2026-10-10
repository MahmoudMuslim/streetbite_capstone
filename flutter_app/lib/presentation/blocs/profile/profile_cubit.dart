import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/usecase/usecase.dart';
import '../../../domain/entities/device_info_entity.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/get_device_info.dart';
import '../../../domain/usecases/pick_and_upload_photo.dart';
import 'profile_state.dart';

/// Owns the Profile screen state: the signed-in user, the device metadata and
/// the photo-upload progress.
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required this._getDeviceInfo,
    required this._pickAndUploadPhoto,
    required UserEntity user,
  }) : super(ProfileState(user: user));

  final GetDeviceInfo _getDeviceInfo;
  final PickAndUploadPhoto _pickAndUploadPhoto;

  /// Reads the device model + OS version through `device_info_plus`.
  Future<void> loadDeviceInfo() async {
    emit(state.copyWith(isLoadingDevice: true));
    final result = await _getDeviceInfo(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          device: DeviceInfoEntity.unknown,
          isLoadingDevice: false,
          messageKey: failure.messageKey,
        ),
      ),
      (device) => emit(state.copyWith(device: device, isLoadingDevice: false)),
    );
  }

  /// Picks an image and publishes it; emits the new photo URL on success.
  Future<void> changePhoto(ImageSource source) async {
    emit(state.copyWith(isUpdatingPhoto: true, clearMessage: true));
    final result = await _pickAndUploadPhoto(
      PickAndUploadPhotoParams(uid: state.user.uid, source: source),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          isUpdatingPhoto: false,
          // A cancelled picker is not an error the user needs to hear about.
          messageKey: failure.messageKey == 'failureCancelled'
              ? null
              : failure.messageKey,
        ),
      ),
      (photoUrl) => emit(
        state.copyWith(
          user: state.user.copyWith(photoUrl: photoUrl),
          isUpdatingPhoto: false,
          messageKey: 'photoUpdated',
        ),
      ),
    );
  }

  /// Clears the one-shot SnackBar message once it has been shown.
  void consumeMessage() => emit(state.copyWith(clearMessage: true));

  /// Keeps the profile in sync when the auth state changes (e.g. after login).
  void updateUser(UserEntity user) => emit(state.copyWith(user: user));
}
