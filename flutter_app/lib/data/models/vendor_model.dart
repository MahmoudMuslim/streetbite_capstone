import '../../domain/entities/vendor_entity.dart';

/// Firestore / API representation of a street-food vendor.
class VendorModel {
  const VendorModel({
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

  static const String idKey = 'id';
  static const String nameKey = 'name';
  static const String cuisineKey = 'cuisine';
  static const String ratingKey = 'rating';
  static const String latitudeKey = 'lat';
  static const String longitudeKey = 'lng';
  static const String distanceKmKey = 'distanceKm';
  static const String thumbnailKey = 'thumbnailUrl';
  static const String addressKey = 'address';

  final String id;
  final String name;
  final String cuisine;
  final double rating;
  final double latitude;
  final double longitude;
  final double distanceKm;
  final String thumbnailUrl;
  final String address;

  factory VendorModel.fromJson(Map<String, dynamic> json) => VendorModel(
    id: (json[idKey] ?? '').toString(),
    name: (json[nameKey] ?? '').toString(),
    cuisine: (json[cuisineKey] ?? '').toString(),
    rating: (json[ratingKey] as num?)?.toDouble() ?? 0,
    latitude: (json[latitudeKey] as num?)?.toDouble() ?? 0,
    longitude: (json[longitudeKey] as num?)?.toDouble() ?? 0,
    distanceKm: (json[distanceKmKey] as num?)?.toDouble() ?? 0,
    thumbnailUrl: (json[thumbnailKey] ?? '').toString(),
    address: (json[addressKey] ?? '').toString(),
  );

  factory VendorModel.fromEntity(VendorEntity entity) => VendorModel(
    id: entity.id,
    name: entity.name,
    cuisine: entity.cuisine,
    rating: entity.rating,
    latitude: entity.latitude,
    longitude: entity.longitude,
    distanceKm: entity.distanceKm,
    thumbnailUrl: entity.thumbnailUrl,
    address: entity.address,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    idKey: id,
    nameKey: name,
    cuisineKey: cuisine,
    ratingKey: rating,
    latitudeKey: latitude,
    longitudeKey: longitude,
    distanceKmKey: distanceKm,
    thumbnailKey: thumbnailUrl,
    addressKey: address,
  };

  VendorEntity toEntity() => VendorEntity(
    id: id,
    name: name,
    cuisine: cuisine,
    rating: rating,
    latitude: latitude,
    longitude: longitude,
    distanceKm: distanceKm,
    thumbnailUrl: thumbnailUrl,
    address: address,
  );
}
