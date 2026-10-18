import 'package:equatable/equatable.dart';

import '../../../domain/entities/device_info_entity.dart';
import '../../../domain/entities/user_entity.dart';

/// States emitted by [ProfileCubit] — everything the Profile screen renders.
class ProfileState extends Equatable {
  const ProfileState({
    required this.user,
    this.device = DeviceInfoEntity.unknown,
    this.isLoadingDevice = false,
    this.isUpdatingPhoto = false,
    this.messageKey,
  });

  final UserEntity user;
  final DeviceInfoEntity device;

  /// `true` while `device_info_plus` is answering.
  final bool isLoadingDevice;

  /// `true` while the picked photo is being written to Firestore.
  final bool isUpdatingPhoto;

  /// One-shot ARB key used to show a SnackBar after a photo update.
  final String? messageKey;

  ProfileState copyWith({
    UserEntity? user,
    DeviceInfoEntity? device,
    bool? isLoadingDevice,
    bool? isUpdatingPhoto,
    String? messageKey,
    bool clearMessage = false,
  }) => ProfileState(
    user: user ?? this.user,
    device: device ?? this.device,
    isLoadingDevice: isLoadingDevice ?? this.isLoadingDevice,
    isUpdatingPhoto: isUpdatingPhoto ?? this.isUpdatingPhoto,
    messageKey: clearMessage ? null : (messageKey ?? this.messageKey),
  );

  @override
  List<Object?> get props => [
    user,
    device,
    isLoadingDevice,
    isUpdatingPhoto,
    messageKey,
  ];
}
