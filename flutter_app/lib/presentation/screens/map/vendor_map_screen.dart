import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/usecase/usecase.dart';
import '../../../core/utils/responsive.dart';
import '../../../domain/entities/vendor_entity.dart';
import '../../../domain/usecases/get_nearby_vendors.dart';
import '../../extensions/l10n_extension.dart';
import '../../widgets/app_error_view.dart';
import '../../widgets/app_loading_view.dart';
import '../../widgets/map_error_boundary.dart';
import '../../widgets/vendor_info_window.dart';
import '../../widgets/vendor_marker.dart';

/// Full-screen "Nearby Vendors" map with five pinned markers across five
/// cities.
///
/// Failure handling is the interesting part: `google_maps_flutter` renders
/// through a platform view, so on a device without Play Services or a valid API
/// key it can throw while building. The map therefore sits inside an
/// [ErrorWidget.builder] that swaps in [AppErrorView] — that is how the
/// "no unhandled exceptions anywhere" rule also covers the map.
class VendorMapScreen extends StatefulWidget {
  const VendorMapScreen({super.key});

  @override
  State<VendorMapScreen> createState() => _VendorMapScreenState();
}

class _VendorMapScreenState extends State<VendorMapScreen> {
  /// Identifier of this map instance, required by [GoogleMapController.init].
  static const String _mapId = 'streetbite.vendor_map';

  /// Handed to us by `GoogleMap.onMapCreated`; it cannot be created eagerly
  /// because it needs the platform view to exist first.
  GoogleMapController? _controller;

  List<VendorEntity> _vendors = const [];
  String? _selectedVendorId;
  String? _errorKey;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final GetNearbyVendors useCase = GetIt.I<GetNearbyVendors>();
    final result = await useCase(const NoParams());
    if (!mounted) return;

    result.fold(
      (failure) => setState(() {
        _errorKey = failure.messageKey;
        _isLoading = false;
      }),
      (vendors) => setState(() {
        _vendors = vendors;
        _isLoading = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.vendorMap)),
      body: _isLoading
          ? const AppLoadingView()
          : _errorKey != null
          ? AppErrorView(
              messageKey: _errorKey!,
              icon: Icons.map_outlined,
              onRetry: () {
                setState(() {
                  _errorKey = null;
                  _isLoading = true;
                });
                _load();
              },
            )
          : _buildMap(context),
    );
  }

  Widget _buildMap(BuildContext context) {
    final position = _initialPosition();

    return MapErrorBoundary(
      fallbackBuilder: (context, error) => AppErrorView(
        messageKey: 'failureGeneric',
        icon: Icons.map_outlined,
        onRetry: _load,
      ),
      child: Responsive.constrainWidth(
        context,
        child: Stack(
          children: [
            GoogleMap(
              key: const ValueKey('vendor_google_map'),
              mapId: _mapId,
              initialCameraPosition: position,
              markers: VendorMarker.buildAll(
                _vendors,
                selectedId: _selectedVendorId,
                onTap: _onMarkerTap,
              ),
              onMapCreated: (controller) => _controller = controller,
              onTap: (_) => setState(() => _selectedVendorId = null),

              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
            ),
            // The info window floats above the map rather than being pinned to
            // the marker, which keeps it readable in both orientations and
            // avoids Google's very small default bubble.
            if (_selectedVendor != null)
              Positioned(
                left: 16,
                right: 16,
                bottom: 24,
                child: VendorInfoWindow(
                  vendor: _selectedVendor!,
                  onClose: () => setState(() => _selectedVendorId = null),
                  onDirections: () => _showDirections(_selectedVendor!),
                ),
              ),
          ],
        ),
      ),
    );
  }

  VendorEntity? get _selectedVendor {
    final id = _selectedVendorId;
    if (id == null) return null;
    return _vendors.firstWhere((vendor) => vendor.id == id);
  }

  /// Camera that frames every marker, so no vendor is off-screen on launch.
  CameraPosition _initialPosition() {
    if (_vendors.isEmpty) {
      return const CameraPosition(target: LatLng(30.0444, 31.2357), zoom: 2);
    }
    double minLat = _vendors.first.latitude;
    double maxLat = minLat;
    double minLng = _vendors.first.longitude;
    double maxLng = minLng;

    for (final vendor in _vendors) {
      minLat = vendor.latitude < minLat ? vendor.latitude : minLat;
      maxLat = vendor.latitude > maxLat ? vendor.latitude : maxLat;
      minLng = vendor.longitude < minLng ? vendor.longitude : minLng;
      maxLng = vendor.longitude > maxLng ? vendor.longitude : maxLng;
    }

    // A zoom of 2 frames a continent, which is exactly what "vendors across
    // different cities" needs.
    return CameraPosition(
      target: LatLng((minLat + maxLat) / 2, (minLng + maxLng) / 2),
      zoom: 2,
    );
  }

  /// Opens the info window for the tapped vendor and centres the camera.
  void _onMarkerTap(String vendorId) {
    final vendor = _vendors.firstWhere((item) => item.id == vendorId);
    setState(() => _selectedVendorId = vendor.id);
    _animateTo(vendor);
  }

  Future<void> _animateTo(VendorEntity vendor) async {
    try {
      await _controller?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(vendor.latitude, vendor.longitude),
          13.5,
        ),
      );
    } catch (_) {
      // The controller detaches when the widget leaves the tree mid-flight;
      // ignoring that keeps the tap non-fatal.
    }
  }

  void _showDirections(VendorEntity vendor) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            '${vendor.name} · ${context.trArgs('vendorDistance', {'distance': context.formatNumber(vendor.distanceKm)})}',
          ),
        ),
      );
  }
}
