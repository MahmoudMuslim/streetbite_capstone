import '../../core/constants/app_constants.dart';
import '../../domain/entities/vendor_entity.dart';
import '../models/vendor_model.dart';

/// Hardcoded seed of street-food vendors pinned on the Nearby Vendors map.
///
/// StreetBite V1 ships five vendors in five different cities so the map
/// demonstrably handles markers spread over a large area (and a wide camera
/// bounds). Replacing this class with a Firestore geo-query later is a
/// **data-source** change only: `VendorRepository` and the map screen stay
/// untouched, which is the whole point of the repository abstraction.
class VendorLocalDataSource {
  const VendorLocalDataSource();

  /// City centres used to build the camera bounds.
  static const List<({String city, double lat, double lng})> _cities = [
    (city: 'Cairo', lat: 30.0444, lng: 31.2357),
    (city: 'Dubai', lat: 25.2048, lng: 55.2708),
    (city: 'London', lat: 51.5072, lng: -0.1276),
    (city: 'New York', lat: 40.7128, lng: -74.0060),
    (city: 'Tokyo', lat: 35.6762, lng: 139.6503),
  ];

  /// Returns the vendor list, trimmed to [AppConstants.vendorCount].
  List<VendorModel> getVendors() {
    const catalogue = <VendorModel>[
      VendorModel(
        id: 'vendor-cairo-1',
        name: 'Ful & Koshari El Dahab',
        cuisine: 'Egyptian street food',
        rating: 4.9,
        latitude: 30.0462,
        longitude: 31.2369,
        distanceKm: 0.8,
        thumbnailUrl:
            'https://www.themealdb.com/images/media/meals/ustsqw1468250014.jpg',
        address: 'Tahrir Square, Downtown, Cairo',
      ),
      VendorModel(
        id: 'vendor-dubai-1',
        name: 'Shawarma Al Thuraya',
        cuisine: 'Levantine grill',
        rating: 4.7,
        latitude: 25.2058,
        longitude: 55.2712,
        distanceKm: 1.4,
        thumbnailUrl:
            'https://www.themealdb.com/images/media/meals/wtsvxx1511296896.jpg',
        address: 'Al Fahidi Historical Neighbourhood, Dubai',
      ),
      VendorModel(
        id: 'vendor-london-1',
        name: 'Borough Market Burgers',
        cuisine: 'Smash burgers',
        rating: 4.8,
        latitude: 51.5055,
        longitude: -0.0910,
        distanceKm: 2.2,
        thumbnailUrl:
            'https://www.themealdb.com/images/media/meals/58oia61564916529.jpg',
        address: 'Borough Market, Southwark, London',
      ),
      VendorModel(
        id: 'vendor-ny-1',
        name: 'Corner Tacostand',
        cuisine: 'Mexican street tacos',
        rating: 4.6,
        latitude: 40.7180,
        longitude: -73.9970,
        distanceKm: 3.1,
        thumbnailUrl:
            'https://www.themealdb.com/images/media/meals/wtsvxx1511296896.jpg',
        address: 'Lower East Side, New York',
      ),
      VendorModel(
        id: 'vendor-tokyo-1',
        name: 'Ramen Yokocho Lantern',
        cuisine: 'Tokyo ramen',
        rating: 4.9,
        latitude: 35.6780,
        longitude: 139.6520,
        distanceKm: 5.6,
        thumbnailUrl:
            'https://www.themealdb.com/images/media/meals/1525876468.jpg',
        address: 'Shinjuku, Tokyo',
      ),
    ];

    return catalogue.take(AppConstants.vendorCount).toList();
  }

  /// City centres, exposed so the map can frame every marker at once.
  List<({String city, double lat, double lng})> get cities => _cities;

  /// Convenience mapping to domain entities.
  List<VendorEntity> getVendorEntities() =>
      getVendors().map((vendor) => vendor.toEntity()).toList();
}
