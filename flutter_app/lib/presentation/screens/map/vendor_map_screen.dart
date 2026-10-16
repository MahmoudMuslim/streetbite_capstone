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
/// Failure handling is the interesting part, and it took two layers to get
/// right.
///
/// `google_maps_flutter` renders through a platform view, so a map that cannot
/// authenticate does **not** throw where Dart can see it: the platform view
/// simply paints black. That defeats a plain [ErrorWidget.builder], so the map
/// is additionally given a deadline. If [GoogleMap.onMapCreated] has not fired
/// within [_mapStartupTimeout] the widget swaps in [AppErrorView] itself.
///
/// The deadline matters more than it looks. When the Maps API key is missing or
/// rejected, Google's SDK retries token acquisition *on the UI thread*, and the
/// app stops responding entirely - Android eventually shows "StreetBite isn't
/// responding" and kills it. A map that times out into a readable error costs
/// the user one retry button; a map that blocks costs them the whole session.
class VendorMapScreen extends StatefulWidget {
  const VendorMapScreen({super.key});

  /// How long to wait for the platform view before declaring defeat.
  static const Duration mapStartupTimeout = Duration(seconds: 8);

  @override
  State<VendorMapScreen> createState() => _VendorMapScreenState();
}

class _VendorMapScreenState extends State<VendorMapScreen> {
  /// Identifier of this map instance, required by [GoogleMapController.init].
  static const String _mapId = 'streetbite.vendor_map';

  static const Duration _mapStartupTimeout = VendorMapScreen.mapStartupTimeout;

  /// Handed to us by `GoogleMap.onMapCreated`; it cannot be created eagerly
  /// because it needs the platform view to exist first.
  GoogleMapController? _controller;

  List<VendorEntity> _vendors = const [];
  String? _selectedVendorId;
  String? _errorKey;
  bool _isLoading = true;

  /// `true` once the platform view reported in, which is the only reliable
  /// signal that the map is actually going to draw.
  bool _mapReady = false;

  /// Guards [_startupDeadline] so each attempt arms exactly one timer.
  bool _deadlineArmed = false;

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
              onRetry: _retry,
            )
          : _buildMap(context),
    );
  }

  /// Re-arms the startup deadline and re-reads the vendors.
  void _retry() {
    setState(() {
      _errorKey = null;
      _isLoading = true;
      _mapReady = false;
      _deadlineArmed = false;
    });
    _load();
  }

  /// Fails the map into an error view when the platform view never reports in.
  void _onMapStartupTimeout() {
    if (!mounted || _mapReady) return;
    setState(() {
      _deadlineArmed = false;
      _mapReady = false;
      _errorKey = 'failureGeneric';
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    if (!mounted) return;
    setState(() {
      _mapReady = true;
      _deadlineArmed = false;
    });
  }

  Widget _buildMap(BuildContext context) {
    final position = _initialPosition();

    // Arm the deadline as the map is placed, and cancel it the moment the
    // platform view reports success.
    if (!_deadlineArmed && !_mapReady) {
      _deadlineArmed = true;
      Future<void>.delayed(_mapStartupTimeout, _onMapStartupTimeout);
    }

    return MapErrorBoundary(
      fallbackBuilder: (context, error) => AppErrorView(
        messageKey: 'failureGeneric',
        icon: Icons.map_outlined,
        onRetry: _retry,
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
              onMapCreated: _onMapCreated,
              onTap: (_) => setState(() => _selectedVendorId = null),

              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
            ),
            // A rejected or missing Maps key paints a blank canvas with no
            // Dart-visible error, so the markers cannot be tapped either. The
            // list keeps every vendor reachable - and the info window, which
            // is a Flutter widget, fully usable - until the key is fixed.
            Positioned(
              right: 16,
              top: 16,
              child: Material(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(24),
                elevation: 3,
                child: InkWell(
                  key: const ValueKey('vendor_list_button'),
                  onTap: _showVendorList,
                  borderRadius: BorderRadius.circular(24),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.list_rounded, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          context.l10n.vendorList,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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

  /// Bottom sheet listing every vendor, for when the tiles cannot draw.
  ///
  /// Selecting a row does exactly what tapping its marker does: the info
  /// window opens and the camera animates, so the sheet is a second door to
  /// the same feature rather than a parallel implementation.
  Future<void> _showVendorList() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Text(
                context.l10n.vendorList,
                style: Theme.of(sheetContext).textTheme.titleLarge,
              ),
            ),
            for (final vendor in _vendors)
              ListTile(
                key: ValueKey('vendor_list_${vendor.id}'),
                leading: const Icon(Icons.storefront_rounded),
                title: Text(vendor.name),
                subtitle: Text(
                  '${vendor.cuisine} · ${vendor.rating.toStringAsFixed(1)}',
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => Navigator.of(sheetContext).pop(vendor.id),
              ),
          ],
        ),
      ),
    );

    if (selected == null || !mounted) return;
    _onMarkerTap(selected);
  }

  VendorEntity? get _selectedVendor {
    final id = _selectedVendorId;
    if (id == null) return null;
    // A plain `firstWhere` throws a StateError the moment the selected id is
    // not in the list (a stale selection after a failed reload), which would
    // crash the screen mid-gesture.
    for (final vendor in _vendors) {
      if (vendor.id == id) return vendor;
    }
    return null;
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
