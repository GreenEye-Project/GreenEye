import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class DashboardController extends ChangeNotifier {
  EnvironmentData? data;
  bool isLoading = true;
  String? error;

  static const _baseUrl = 'https://radwaamr1-realtime-api.hf.space';

  DashboardController() {
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      // Get user location
      final position = await _getLocation();

      // Call the new API
      final response = await http.post(
        Uri.parse('$_baseUrl/extract-ml-features'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'latitude': position.latitude,
          'longitude': position.longitude,
        }),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['success'] == true) {
          data = EnvironmentData.fromJson(json);
        } else {
          error = 'Failed to load data: API returned success=false';
        }
      } else {
        error = 'Failed to load data: ${response.statusCode}';
      }
    } catch (e) {
      if (e is LocationServiceDisabledException) {
        error =
            'Location services are disabled. Please enable location services.';
      } else if (e is PermissionDeniedException) {
        error = 'Location permission denied. Please grant location permission.';
      } else {
        error = 'Error: ${e.toString()}';
      }
    }

    isLoading = false;
    notifyListeners();
  }

  Future<Position> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw LocationServiceDisabledException();
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw PermissionDeniedException('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw PermissionDeniedException(
        'Location permissions are permanently denied',
      );
    }

    // Get current position
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}

class EnvironmentData {
  final bool success;
  final Features features;
  final Metadata metadata;

  EnvironmentData({
    required this.success,
    required this.features,
    required this.metadata,
  });

  factory EnvironmentData.fromJson(Map<String, dynamic> json) {
    return EnvironmentData(
      success: json['success'] ?? false,
      features: Features.fromJson(json['features'] ?? {}),
      metadata: Metadata.fromJson(json['metadata'] ?? {}),
    );
  }

  // Convenience getters for common fields
  String get locationName => metadata.locationName;
  double get temperatureC => features.t2mC;
  double get relativeHumidityPercent => features.rhPct;
  double get ndvi => features.ndvi;
  double get ph => features.ph;
  double get clay => features.clay;
  double get sand => features.sand;
  double get silt => features.silt;
  double get nitrogen => features.nitrogen;
  double get phosphorus => features.phosphorus;
  double get potassium => features.potassium;
}

class Features {
  final int year;
  final int month;
  final double sand;
  final double silt;
  final double clay;
  final double soc;
  final double ph;
  final double bdod;
  final double cec;
  final double ndvi;
  final double t2mC;
  final double td2mC;
  final double rhPct;
  final double? tpM;
  final double? ssrdJm2;
  final int lcType1;
  final double nitrogen;
  final double phosphorus;
  final double potassium;
  final double latitude;
  final double longitude;

  Features({
    required this.year,
    required this.month,
    required this.sand,
    required this.silt,
    required this.clay,
    required this.soc,
    required this.ph,
    required this.bdod,
    required this.cec,
    required this.ndvi,
    required this.t2mC,
    required this.td2mC,
    required this.rhPct,
    this.tpM,
    this.ssrdJm2,
    required this.lcType1,
    required this.nitrogen,
    required this.phosphorus,
    required this.potassium,
    required this.latitude,
    required this.longitude,
  });

  factory Features.fromJson(Map<String, dynamic> json) {
    return Features(
      year: json['year'] ?? 0,
      month: json['month'] ?? 0,
      sand: (json['sand'] ?? 0).toDouble(),
      silt: (json['silt'] ?? 0).toDouble(),
      clay: (json['clay'] ?? 0).toDouble(),
      soc: (json['soc'] ?? 0).toDouble(),
      ph: (json['ph'] ?? 0).toDouble(),
      bdod: (json['bdod'] ?? 0).toDouble(),
      cec: (json['cec'] ?? 0).toDouble(),
      ndvi: (json['ndvi'] ?? 0).toDouble(),
      t2mC: (json['t2m_c'] ?? 0).toDouble(),
      td2mC: (json['td2m_c'] ?? 0).toDouble(),
      rhPct: (json['rh_pct'] ?? 0).toDouble(),
      tpM: json['tp_m'] != null ? (json['tp_m'] as num).toDouble() : null,
      ssrdJm2: json['ssrd_jm2'] != null
          ? (json['ssrd_jm2'] as num).toDouble()
          : null,
      lcType1: json['lc_type1'] ?? 0,
      nitrogen: (json['nitrogen'] ?? 0).toDouble(),
      phosphorus: (json['phosphorus'] ?? 0).toDouble(),
      potassium: (json['potassium'] ?? 0).toDouble(),
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
    );
  }
}

class Metadata {
  final String locationName;
  final String queryTimestamp;
  final double dataQuality;
  final String soilRetrievalMethod;
  final String npkConfidence;
  final String ndviSource;
  final String lcSource;

  Metadata({
    required this.locationName,
    required this.queryTimestamp,
    required this.dataQuality,
    required this.soilRetrievalMethod,
    required this.npkConfidence,
    required this.ndviSource,
    required this.lcSource,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      locationName: json['location_name'] ?? 'Unknown Location',
      queryTimestamp: json['query_timestamp'] ?? '',
      dataQuality: (json['data_quality'] ?? 0).toDouble(),
      soilRetrievalMethod: json['soil_retrieval_method'] ?? '',
      npkConfidence: json['npk_confidence'] ?? 'Unknown',
      ndviSource: json['ndvi_source'] ?? '',
      lcSource: json['lc_source'] ?? '',
    );
  }
}

// Custom exceptions for better error handling
class LocationServiceDisabledException implements Exception {}

class PermissionDeniedException implements Exception {
  final String message;
  PermissionDeniedException(this.message);

  @override
  String toString() => message;
}
