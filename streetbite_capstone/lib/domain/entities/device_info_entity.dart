import 'package:equatable/equatable.dart';

/// Device metadata surfaced on the Profile screen, sourced from
/// `device_info_plus`. Reading it behind an entity keeps the plugin out of the
/// presentation layer and makes the profile screen trivially testable.
class DeviceInfoEntity extends Equatable {
  const DeviceInfoEntity({
    required this.model,
    required this.osVersion,
    required this.deviceName,
    required this.manufacturer,
  });

  final String model;

  /// e.g. `Android 14`.
  final String osVersion;

  final String deviceName;
  final String manufacturer;

  /// Value used when `device_info_plus` cannot answer (e.g. on web/desktop).
  static const DeviceInfoEntity unknown = DeviceInfoEntity(
    model: 'Unknown',
    osVersion: 'Unknown',
    deviceName: 'Unknown',
    manufacturer: 'Unknown',
  );

  @override
  List<Object?> get props => [model, osVersion, deviceName, manufacturer];
}
