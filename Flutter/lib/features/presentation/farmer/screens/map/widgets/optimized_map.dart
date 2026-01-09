import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class OptimizedMap extends StatefulWidget {
  final ValueChanged<LatLng> onPointSelected;
  final List<LatLng> pinnedLocations;

  const OptimizedMap({
    super.key,
    required this.onPointSelected,
    this.pinnedLocations = const [],
  });

  /* ───────────── MAP CONTROLLER ───────────── */

  static final MapController _controller = MapController();

  /// Sinai default location (Sharm El-Sheikh area)
  static const LatLng sinaiCenter = LatLng(28.0, 34.0);

  /// Egypt bounding box (safe margins)
  static final LatLngBounds egyptBounds = LatLngBounds(
    const LatLng(22.0, 24.5),
    const LatLng(31.7, 36.9),
  );

  static void animateTo(double lat, double lng, {double zoom = 17}) {
    final target = LatLng(lat, lng);

    if (!egyptBounds.contains(target)) {
      _controller.move(sinaiCenter, 13);
      return;
    }

    _controller.move(target, zoom);
  }

  @override
  State<OptimizedMap> createState() => _OptimizedMapState();
}

class _OptimizedMapState extends State<OptimizedMap> {
  LatLng? _selectedPoint;

  bool _isInsideEgypt(LatLng point) {
    return OptimizedMap.egyptBounds.contains(point);
  }

  @override
  void initState() {
    super.initState();

    /// Force Sinai on first load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      OptimizedMap.animateTo(
        OptimizedMap.sinaiCenter.latitude,
        OptimizedMap.sinaiCenter.longitude,
        zoom: 9,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: OptimizedMap._controller,
      options: MapOptions(
        initialCenter: OptimizedMap.sinaiCenter,
        initialZoom: 9,

        /// 🔒 HARD EGYPT LOCK
        cameraConstraint: CameraConstraint.contain(
          bounds: OptimizedMap.egyptBounds,
        ),

        minZoom: 6,
        maxZoom: 18,

        onTap: (_, point) {
          if (!_isInsideEgypt(point)) {
            _snapBackToEgypt();
            return;
          }

          setState(() => _selectedPoint = point);
          widget.onPointSelected(point);
        },

        /// 🧲 Snap back if user drags outside Egypt
        onPositionChanged: (position, hasGesture) {
          // ignore: unnecessary_null_comparison
          if (!hasGesture || position.center == null) return;

          final center = position.center!;
          if (!_isInsideEgypt(center)) {
            _snapBackToEgypt();
          }
        },
      ),
      children: [
        /* ───────────── MAP TILES ───────────── */
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.project',
        ),

        /* ───────────── SELECTED POINT ───────────── */
        if (_selectedPoint != null)
          MarkerLayer(
            markers: [
              Marker(
                point: _selectedPoint!,
                width: 18,
                height: 18,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                ),
              ),
            ],
          ),

        /* ───────────── PINNED LOCATIONS ───────────── */
        if (widget.pinnedLocations.isNotEmpty)
          MarkerLayer(
            markers: widget.pinnedLocations.map((point) {
              return Marker(
                point: point,
                width: 18,
                height: 18,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  /* ───────────── HELPERS ───────────── */

  void _snapBackToEgypt() {
    OptimizedMap.animateTo(
      OptimizedMap.sinaiCenter.latitude,
      OptimizedMap.sinaiCenter.longitude,
      zoom: 9,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Map is limited to Egypt only'),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
