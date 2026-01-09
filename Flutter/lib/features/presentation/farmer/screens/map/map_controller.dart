import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../../core/theme/app_colors.dart';

class DesertificationApiController {
  static const String baseUrl = 'https://greeneyeaifeatures.runasp.net';

  /* ───────────── CLASSIFICATION (REAL API) ───────────── */

  /// Get desertification classification for a specific location
  static Future<ClassificationResponse?> getClassification({
    required double latitude,
    required double longitude,
  }) async {
    try {
      // Construct URI with query parameters
      final uri = Uri.parse('$baseUrl/api/Classification').replace(
        queryParameters: {
          'latitude': latitude.toString(),
          'longitude': longitude.toString(),
        },
      );

      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return ClassificationResponse.fromJson(jsonDecode(response.body));
      } else {
        debugPrint('Classification API error: ${response.statusCode}');
        debugPrint('Classification API body: ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('Classification request failed: $e');
      return null;
    }
  }

  /* ───────────── FORECAST (REAL API USING GET) ───────────── */

  static Future<ForecastResponse?> getForecast({
    required double latitude,
    required double longitude,
  }) async {
    try {
      // Construct URI with query parameters
      final uri = Uri.parse(
        '$baseUrl/api/Forecasting/forecast?latitude=$latitude&longitude=$longitude',
      );

      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return ForecastResponse.fromJson(jsonDecode(response.body));
      } else {
        debugPrint('Forecast API error: ${response.statusCode}');
        debugPrint('Forecast API body: ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('Forecast request failed: $e');
      return null;
    }
  }

  /* ───────────── CROP RECOMMENDATION (REAL API USING GET) ───────────── */

  static Future<CropRecommendationResponse?> getCropRecommendation({
    required double latitude,
    required double longitude,
  }) async {
    try {
      // Construct URI with query parameters
      final uri = Uri.parse(
        '$baseUrl/api/CropRecommendation/recommend?latitude=$latitude&longitude=$longitude',
      );

      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return CropRecommendationResponse.fromJson(jsonDecode(response.body));
      } else {
        debugPrint('Crop Recommendation API error: ${response.statusCode}');
        debugPrint('Crop Recommendation API body: ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('Crop Recommendation request failed: $e');
      return null;
    }
  }
}

/* ───────────── MODELS ───────────── */

class ClassificationResponse {
  final bool isSuccess;
  final String? message;
  final ClassificationData? data;

  ClassificationResponse({required this.isSuccess, this.message, this.data});

  factory ClassificationResponse.fromJson(Map<String, dynamic> json) {
    return ClassificationResponse(
      isSuccess: json['isSuccess'] ?? false,
      message: json['message'],
      data: json['data'] != null
          ? ClassificationData.fromJson(json['data'])
          : null,
    );
  }
}

class ClassificationData {
  final Prediction prediction;
  final Metadata metadata;

  ClassificationData({required this.prediction, required this.metadata});

  factory ClassificationData.fromJson(Map<String, dynamic> json) {
    return ClassificationData(
      prediction: Prediction.fromJson(json['prediction']),
      metadata: Metadata.fromJson(json['metadata']),
    );
  }
}

class Prediction {
  final String desertificationLevel;
  final double confidence;

  Prediction({required this.desertificationLevel, required this.confidence});

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      desertificationLevel: json['desertification_level'] ?? 'Unknown',
      confidence: (json['confidence'] ?? 0).toDouble(),
    );
  }

  String get displayLevel {
    switch (desertificationLevel.toLowerCase()) {
      case 'low':
        return 'Low';
      case 'moderate':
      case 'medium':
        return 'Moderate';
      case 'high':
        return 'High';
      default:
        return desertificationLevel;
    }
  }

  Color get levelColor {
    switch (desertificationLevel.toLowerCase()) {
      case 'low':
        return AppColors.good;
      case 'moderate':
      case 'medium':
        return AppColors.medium;
      case 'high':
        return AppColors.critical;
      default:
        return AppColors.grey;
    }
  }
}

class Metadata {
  final String locationName;

  Metadata({required this.locationName});

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(locationName: json['location_name'] ?? 'Unknown Location');
  }
}

/* ───────────── FORECAST MODELS ───────────── */

class ForecastResponse {
  final bool isSuccess;
  final String? message;
  final ForecastData? data;

  ForecastResponse({required this.isSuccess, this.message, this.data});

  factory ForecastResponse.fromJson(Map<String, dynamic> json) {
    return ForecastResponse(
      isSuccess: json['isSuccess'] ?? false,
      message: json['message'],
      data: json['data'] != null ? ForecastData.fromJson(json['data']) : null,
    );
  }
}

class ForecastData {
  final double latitude;
  final double longitude;
  final String locationName;
  final List<ForecastItem> forecasts;
  final String? generatedAt;

  ForecastData({
    required this.latitude,
    required this.longitude,
    required this.locationName,
    required this.forecasts,
    this.generatedAt,
  });

  factory ForecastData.fromJson(Map<String, dynamic> json) {
    return ForecastData(
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      locationName: json['locationName'] ?? 'Unknown Location',
      forecasts: (json['forecasts'] as List? ?? [])
          .map((e) => ForecastItem.fromJson(e))
          .toList(),
      generatedAt: json['generatedAt'],
    );
  }
}

class ForecastItem {
  final int year;
  final int month;
  final double ndvi;
  final double t2mC;
  final double? td2mC;
  final double rhPct;
  final double tpM;
  final int? ssrdJm2;
  final String riskLevel;
  final double riskConfidence;

  ForecastItem({
    required this.year,
    required this.month,
    required this.ndvi,
    required this.t2mC,
    this.td2mC,
    required this.rhPct,
    required this.tpM,
    this.ssrdJm2,
    required this.riskLevel,
    required this.riskConfidence,
  });

  factory ForecastItem.fromJson(Map<String, dynamic> json) {
    return ForecastItem(
      year: json['year'] ?? 0,
      month: json['month'] ?? 0,
      ndvi: (json['ndvi'] ?? 0).toDouble(),
      t2mC: (json['t2m_c'] ?? 0).toDouble(),
      td2mC: json['td2m_c'] != null ? (json['td2m_c']).toDouble() : null,
      rhPct: (json['rh_pct'] ?? 0).toDouble(),
      tpM: (json['tp_m'] ?? 0).toDouble(),
      ssrdJm2: json['ssrd_jm2'],
      riskLevel: json['risk_level'] ?? 'Unknown',
      riskConfidence: (json['risk_confidence'] ?? 0).toDouble(),
    );
  }

  String get monthName => const [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ][month - 1];

  Color get riskColor {
    switch (riskLevel.toLowerCase()) {
      case 'low':
        return AppColors.good;
      case 'medium':
      case 'moderate':
        return AppColors.medium;
      case 'high':
        return AppColors.critical;
      default:
        return AppColors.grey;
    }
  }

  String get riskTimeframe {
    final now = DateTime.now();
    final monthsDiff = (year - now.year) * 12 + (month - now.month);

    if (monthsDiff <= 0) return 'Current';
    if (monthsDiff <= 12) return 'Within 1 year';

    final yearsDiff = (monthsDiff / 12).ceil();
    return 'Within $yearsDiff years';
  }
}

/* ───────────── CROP RECOMMENDATION MODELS ───────────── */

class CropRecommendationResponse {
  final bool isSuccess;
  final String? message;
  final CropRecommendationData? data;

  CropRecommendationResponse({
    required this.isSuccess,
    this.message,
    this.data,
  });

  factory CropRecommendationResponse.fromJson(Map<String, dynamic> json) {
    return CropRecommendationResponse(
      isSuccess: json['isSuccess'] ?? false,
      message: json['message'],
      data: json['data'] != null
          ? CropRecommendationData.fromJson(json['data'])
          : null,
    );
  }
}

class CropRecommendationData {
  final List<String> recommendedCrops;
  final String? generatedAt;

  CropRecommendationData({required this.recommendedCrops, this.generatedAt});

  factory CropRecommendationData.fromJson(Map<String, dynamic> json) {
    return CropRecommendationData(
      recommendedCrops:
          (json['recommended_crops'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      generatedAt: json['generated_at'],
    );
  }
}