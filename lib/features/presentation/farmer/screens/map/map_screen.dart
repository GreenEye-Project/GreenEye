import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'widgets/optimized_map.dart';
import 'widgets/info_panel.dart';
import '/features/auth/location_permission_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final PanelController _panelController = PanelController();
  LatLng? _selectedPoint;
  bool _isLocating = false;

  // List to store pinned locations
  final List<LatLng> _pinnedLocations = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        controller: _panelController,
        minHeight: 0,
        maxHeight: MediaQuery.of(context).size.height * 0.45,
        snapPoint: 0.3,
        backdropEnabled: true,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        panelBuilder: (scrollController) => LandInfoPanel(
          selectedPoint: _selectedPoint,
          scrollController: scrollController,
        ),
        body: Stack(
          children: [
            OptimizedMap(
              pinnedLocations: _pinnedLocations,
              onPointSelected: (point) {
                setState(() => _selectedPoint = point);
                _panelController.open();
              },
            ),

            /// Back button (top-left)
            Positioned(
              top: 50,
              left: 16,
              child: _circleButton(Icons.arrow_back, () {
                Navigator.pop(context);
              }),
            ),

            /// Pin location button (bottom-left)
            Positioned(
              bottom: 140,
              left: 16,
              child: _circleButton(Icons.push_pin, () {
                if (_selectedPoint != null) {
                  setState(() {
                    _pinnedLocations.add(_selectedPoint!);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Location pinned!')),
                  );
                }
              }),
            ),

            /// Saved locations button (bottom-right)
            Positioned(
              bottom: 140,
              right: 16,
              child: _circleButton(Icons.location_on, () {
                if (_pinnedLocations.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No pinned locations yet')),
                  );
                } else {
                  _showPinnedLocations();
                }
              }),
            ),

            /// My location button (with loading state)
            Positioned(
              bottom: 80,
              right: 16,
              child: _isLocating
                  ? Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(color: Colors.black26, blurRadius: 6),
                        ],
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.green,
                          ),
                        ),
                      ),
                    )
                  : _circleButton(Icons.my_location, _goToMyLocation),
            ),
          ],
        ),
      ),
    );
  }

  /// Circle button with onTap callback
  Widget _circleButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
        ),
        child: Icon(icon),
      ),
    );
  }

  /// Show pinned locations in a bottom sheet
  void _showPinnedLocations() {
    showModalBottomSheet(
      context: context,
      builder: (_) => ListView.builder(
        itemCount: _pinnedLocations.length,
        itemBuilder: (context, index) {
          final point = _pinnedLocations[index];
          return ListTile(
            title: Text('Lat: ${point.latitude}, Lng: ${point.longitude}'),
            onTap: () {
              OptimizedMap.animateTo(point.latitude, point.longitude);
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }

  /// Get current location and animate map to it
  Future<void> _goToMyLocation() async {
    setState(() => _isLocating = true);

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _isLocating = false);
        await _navigateToPermissionScreen();
        return;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _isLocating = false);
        await _navigateToPermissionScreen();
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() => _isLocating = false);
        await _navigateToPermissionScreen();
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.bestForNavigation,
          distanceFilter: 0,
        ),
      );

      // Animate to current location
      final myLocation = LatLng(position.latitude, position.longitude);
      OptimizedMap.animateTo(position.latitude, position.longitude);

      // Set as selected point and open panel
      setState(() {
        _selectedPoint = myLocation;
        _isLocating = false;
      });

      _panelController.open();

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Located at: ${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}',
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      setState(() => _isLocating = false);
      _showLocationError('Failed to get location: ${e.toString()}');
    }
  }

  /// Navigate to permission screen
  Future<void> _navigateToPermissionScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LocationPermissionScreen()),
    );

    // If user granted permission and we got location
    if (result != null && result is Map<String, dynamic>) {
      final lat = result['latitude'] as double;
      final lng = result['longitude'] as double;

      // Animate to the location
      final myLocation = LatLng(lat, lng);
      OptimizedMap.animateTo(lat, lng);

      // Set as selected point and open panel
      setState(() {
        _selectedPoint = myLocation;
      });

      _panelController.open();

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Located at: ${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  /// Show error message
  void _showLocationError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}
