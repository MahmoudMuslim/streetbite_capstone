import 'package:flutter/material.dart';

/// Catches build/paint errors raised inside its subtree and swaps in a
/// friendly fallback.
///
/// This exists for [GoogleMap]: the widget renders through an Android platform
/// view, so on a device without Google Play Services — or with a missing API
/// key — the failure surfaces through Flutter's `ErrorWidget` mechanism rather
/// than as a catchable Dart exception. A `try/catch` cannot see it; installing a
/// scoped [ErrorWidget.builder] can.
///
/// The previous global handler is always restored in [dispose], so the boundary
/// never leaks its behaviour into the rest of the app.
class MapErrorBoundary extends StatefulWidget {
  const MapErrorBoundary({
    super.key,
    required this.child,
    required this.fallbackBuilder,
  });

  final Widget child;

  /// Called with the captured exception once a failure is observed.
  final Widget Function(BuildContext context, Object error) fallbackBuilder;

  @override
  State<MapErrorBoundary> createState() => _MapErrorBoundaryState();
}

class _MapErrorBoundaryState extends State<MapErrorBoundary> {
  ErrorWidgetBuilder? _previousBuilder;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _install();
  }

  @override
  void dispose() {
    if (_previousBuilder != null) {
      ErrorWidget.builder = _previousBuilder!;
    }
    super.dispose();
  }

  void _install() {
    _previousBuilder = ErrorWidget.builder;
    ErrorWidget.builder = (details) {
      final previous = _previousBuilder;
      previous?.call(details);

      // `ErrorWidget.builder` runs during paint, so the state update has to be
      // deferred to the next frame to avoid mutating state mid-build.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _error != null) return;
        setState(() => _error = details.exception);
      });

      return const SizedBox.shrink();
    };
  }

  @override
  Widget build(BuildContext context) {
    final error = _error;
    if (error != null) return widget.fallbackBuilder(context, error);
    return widget.child;
  }
}
