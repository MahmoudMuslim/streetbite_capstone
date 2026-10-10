import '../../core/error/failures.dart';
import '../../domain/entities/vendor_entity.dart';
import '../../core/error/either.dart';
import '../../domain/repositories/vendor_repository.dart';
import '../datasources/vendor_local_data_source.dart';

/// Serves the vendor list used by the Nearby Vendors map.
///
/// Deliberately synchronous-looking (async signature for symmetry with the
/// other repositories) so that swapping the seed for a Firestore geo-query
/// later touches this file only.
class VendorRepositoryImpl implements VendorRepository {
  const VendorRepositoryImpl(this._local);

  final VendorLocalDataSource _local;

  @override
  Future<Either<Failure, List<VendorEntity>>> getNearbyVendors() async {
    try {
      return Right<Failure, List<VendorEntity>>(_local.getVendorEntities());
    } catch (error) {
      return Left(CacheFailure(details: error.toString()));
    }
  }
}
