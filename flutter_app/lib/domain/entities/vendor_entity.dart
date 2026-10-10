import 'package:equatable/equatable.dart';

/// A street-food vendor pinned on the Nearby Vendors map.
///
/// StreetBite ships five hardcoded vendors (see `vendors.dart` in the data
/// layer) because a production build would swap this list for a geo-query
/// against the vendors collection — the domain contract stays identical.
class VendorEntity extends Equatable {
  const VendorEntity({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.rating,
    required this.latitude,
    required this.longitude,
    required this.distanceKm,
    required this.thumbnailUrl,
    required this.address,
  });

  final String id;
  final String name;
  final String cuisine;
  final double rating;
  final double latitude;
  final double longitude;
  final double distanceKm;
  final String thumbnailUrl;
  final String address;

  @override
  List<Object?> get props => [
    id,
    name,
    cuisine,
    rating,
    latitude,
    longitude,
    distanceKm,
  ];
}
