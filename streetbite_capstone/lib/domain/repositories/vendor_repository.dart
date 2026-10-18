import '../../core/error/failures.dart';
import '../../domain/entities/vendor_entity.dart';
import '../../core/error/either.dart';

/// Contract for the Nearby Vendors map.
abstract interface class VendorRepository {
  /// Returns the vendors to pin on the Google Map.
  Future<Either<Failure, List<VendorEntity>>> getNearbyVendors();
}
