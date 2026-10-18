import '../../core/error/failures.dart';
import '../../core/usecase/usecase.dart';
import '../entities/vendor_entity.dart';
import '../../core/error/either.dart';
import '../repositories/vendor_repository.dart';

/// Returns the vendors pinned on the Nearby Vendors map.
class GetNearbyVendors
    implements UseCase<Either<Failure, List<VendorEntity>>, NoParams> {
  const GetNearbyVendors(this._repository);

  final VendorRepository _repository;

  @override
  Future<Either<Failure, List<VendorEntity>>> call(NoParams params) =>
      _repository.getNearbyVendors();
}
