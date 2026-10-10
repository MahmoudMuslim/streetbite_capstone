import '../../domain/entities/device_info_entity.dart';

/// Serialisable snapshot of `device_info_plus` output.
///
/// Wrapping the plugin's `BaseDeviceInfo` in a model means the Profile screen
/// can be rendered in a widget test (or on desktop) without any platform
/// channel, which is why this class — and not the plugin type — is what flows
/// through the domain layer.
class DeviceInfoModel {
  const DeviceInfoModel({
    required this.model,
    required this.osVersion,
    required this.deviceName,
    required this.manufacturer,
  });

  static const String modelKey = 'model';
  static const String osVersionKey = 'osVersion';
  static const String deviceNameKey = 'deviceName';
  static const String manufacturerKey = 'manufacturer';

  final String model;
  final String osVersion;
  final String deviceName;
  final String manufacturer;

  factory DeviceInfoModel.fromJson(Map<String, dynamic> json) =>
      DeviceInfoModel(
        model: (json[modelKey] ?? 'Unknown').toString(),
        osVersion: (json[osVersionKey] ?? 'Unknown').toString(),
        deviceName: (json[deviceNameKey] ?? 'Unknown').toString(),
        manufacturer: (json[manufacturerKey] ?? 'Unknown').toString(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
    modelKey: model,
    osVersionKey: osVersion,
    deviceNameKey: deviceName,
    manufacturerKey: manufacturer,
  };

  factory DeviceInfoModel.fromEntity(DeviceInfoEntity entity) =>
      DeviceInfoModel(
        model: entity.model,
        osVersion: entity.osVersion,
        deviceName: entity.deviceName,
        manufacturer: entity.manufacturer,
      );

  DeviceInfoEntity toEntity() => DeviceInfoEntity(
    model: model,
    osVersion: osVersion,
    deviceName: deviceName,
    manufacturer: manufacturer,
  );
}
