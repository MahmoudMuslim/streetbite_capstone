import 'package:device_info_plus/device_info_plus.dart';

import '../../core/error/either.dart';
import '../../core/error/failures.dart';
import '../../core/usecase/usecase.dart';
import '../entities/device_info_entity.dart';

/// Reads the device model and OS version shown on the Profile screen.
///
/// The plugin is wrapped in a use case so that (a) the presentation layer never
/// imports a platform plugin and (b) a failure to read the device degrades to
/// [DeviceInfoEntity.unknown] instead of crashing the screen.
///
/// `BaseDeviceInfo` exposes only a raw `data` map, while the platform classes
/// (`AndroidDeviceInfo`, `IosDeviceInfo`, ...) expose typed getters. The code
/// below prefers the typed value and falls back to the map, which is what lets
/// one use case serve Android, iOS and desktop from the same source.
class GetDeviceInfo
    implements UseCase<Either<Failure, DeviceInfoEntity>, NoParams> {
  const GetDeviceInfo(this._info);

  final DeviceInfoPlugin _info;

  @override
  Future<Either<Failure, DeviceInfoEntity>> call(NoParams params) async {
    try {
      final base = await _info.deviceInfo;
      final data = base.data;

      final model =
          _stringOf(base, 'model') ??
          _fromMap(data, 'model') ??
          DeviceInfoEntity.unknown.model;
      final osName = _stringOf(base, 'name') ?? _osNameFromVersion(data);
      final osVersion =
          _stringOf(base, 'version') ?? _fromMap(data, 'version') ?? '';
      final manufacturer =
          _stringOf(base, 'manufacturer') ??
          _fromMap(data, 'manufacturer') ??
          model;
      final deviceName = _stringOf(base, 'name') ?? model;

      return Right<Failure, DeviceInfoEntity>(
        DeviceInfoEntity(
          model: model,
          osVersion: osVersion.isEmpty ? osName : '$osName $osVersion',
          deviceName: deviceName,
          manufacturer: manufacturer.isEmpty ? model : manufacturer,
        ),
      );
    } catch (_) {
      // device_info_plus throws on unsupported platforms (web, unit tests).
      return const Right<Failure, DeviceInfoEntity>(DeviceInfoEntity.unknown);
    }
  }

  /// Reads a typed getter when the concrete platform class provides one.
  static String? _stringOf(BaseDeviceInfo info, String getter) {
    try {
      final value = switch (info) {
        AndroidDeviceInfo() => switch (getter) {
          'model' => info.model,
          'name' => info.name,
          'version' => info.version.release,
          'manufacturer' => info.manufacturer,
          _ => null,
        },
        IosDeviceInfo() => switch (getter) {
          'model' => info.model,
          'name' => info.name,
          'version' => info.systemVersion,
          'manufacturer' => 'Apple',
          _ => null,
        },
        _ => null,
      };
      return value;
    } catch (_) {
      return null;
    }
  }

  static String? _fromMap(Map<String, dynamic> data, String key) {
    final value = data[key];
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  /// `info.version.release` on Android, `systemVersion` on iOS.
  static String _osNameFromVersion(Map<String, dynamic> data) {
    final version = data['version'];
    if (version is Map && version['release'] != null) {
      return 'Android';
    }
    if (data['systemName'] != null) return 'iOS';
    return 'OS';
  }
}
