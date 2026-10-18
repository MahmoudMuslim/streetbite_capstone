import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/theme/app_colors.dart';
import '../../domain/entities/vendor_entity.dart';

/// Marker builder for the Nearby Vendors map.
///
/// Centralising marker creation means every pin looks identical, the info window
/// has a single predictable size, and — since `google_maps_flutter` routes
/// marker taps through `Marker.onTap` rather than `GoogleMap.onMarkerTap` —
/// there is exactly one place where the tap handler is attached.
class VendorMarker {
  const VendorMarker._();

  /// Standard marker for "vendors you have not selected yet".
  static Marker build(VendorEntity vendor, {ValueChanged<String>? onTap}) =>
      Marker(
        markerId: MarkerId(vendor.id),
        position: LatLng(vendor.latitude, vendor.longitude),
        infoWindow: InfoWindow.noText,
        onTap: onTap == null ? null : () => onTap(vendor.id),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      );

  /// Highlighted marker for the currently opened info window.
  static Marker buildSelected(
    VendorEntity vendor, {
    ValueChanged<String>? onTap,
  }) => Marker(
    markerId: MarkerId(vendor.id),
    position: LatLng(vendor.latitude, vendor.longitude),
    infoWindow: InfoWindow.noText,
    onTap: onTap == null ? null : () => onTap(vendor.id),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
  );

  /// Builds the set of markers for the whole map in one pass.
  ///
  /// Passing the same [onTap] to every marker is what guarantees the tap
  /// behaviour cannot drift between pins.
  static Set<Marker> buildAll(
    List<VendorEntity> vendors, {
    String? selectedId,
    ValueChanged<String>? onTap,
  }) => vendors
      .map(
        (vendor) => vendor.id == selectedId
            ? buildSelected(vendor, onTap: onTap)
            : build(vendor, onTap: onTap),
      )
      .toSet();

  /// Brand green, kept next to the markers so the map's chrome matches the
  /// rest of the app without duplicating the hex value.
  static const Color brandColor = AppColors.primary;
}
