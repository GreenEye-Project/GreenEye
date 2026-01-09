import 'dart:io';
import 'package:dio/dio.dart';
import '/core/network/dio_client.dart';
import '/core/constants/api_endpoints.dart';

class DiseaseDetectionController {
  Future<Map<String, dynamic>> scanImage(File imageFile) async {
    try {
      // Check file exists and is readable
      if (!await imageFile.exists()) {
        throw Exception('Image file not found');
      }

      final fileSize = await imageFile.length();
      print('📤 Uploading image: ${imageFile.path.split('/').last}');
      print('📦 File size: ${(fileSize / 1024).toStringAsFixed(2)} KB');

      // Check if file is too large (e.g., > 10MB)
      if (fileSize > 10 * 1024 * 1024) {
        throw Exception(
          'Image file is too large. Please use an image smaller than 10MB.',
        );
      }

      // Validate file is not empty
      if (fileSize == 0) {
        throw Exception('Image file is empty or corrupted');
      }

      // Read file bytes to verify it's readable
      try {
        await imageFile.readAsBytes();
      } catch (e) {
        throw Exception('Unable to read image file. File may be corrupted.');
      }

      // Create form data with 'image' as the key
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
      });

      final endpoint = ApiEndpoints.cropDisease;
      print('🔄 Sending request to: ${ApiEndpoints.baseUrl}$endpoint');

      final response = await DioClient.post(
        endpoint,
        data: formData,
        options: Options(
          receiveTimeout: const Duration(seconds: 90),
          sendTimeout: const Duration(seconds: 60),
        ),
      );

      print('📨 Response status: ${response.statusCode}');
      print('📨 Response data: ${response.data}');

      return _parseResponse(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      print('❌ Unexpected error: $e');
      rethrow;
    }
  }

  /// Parse and validate the API response
  Map<String, dynamic> _parseResponse(dynamic body) {
    if (body == null) {
      throw Exception('Server returned empty response');
    }

    print('📊 Raw response type: ${body.runtimeType}');
    print('📊 Raw response: $body');

    if (body is! Map<String, dynamic>) {
      throw Exception('Invalid response format from server');
    }

    // Check if request was successful
    final isSuccess = body['isSuccess'] ?? body['success'] ?? false;
    if (isSuccess != true) {
      final errorMsg =
          body['message'] ??
          body['error'] ??
          body['Message'] ??
          'Disease scan failed';
      print('❌ Server error: $errorMsg');
      throw Exception(errorMsg);
    }

    // ✅ FIXED: Handle data field correctly
    final dynamic dataRaw = body['data'] ?? body['Data'] ?? body;
    print('📊 Data type received: ${dataRaw.runtimeType}');
    print('📊 Data content: $dataRaw');

    // Handle both array and single object responses
    final List<dynamic> dataList;
    if (dataRaw is List) {
      dataList = dataRaw;
      print('✅ Received array with ${dataList.length} items');
    } else if (dataRaw is Map<String, dynamic>) {
      dataList = [dataRaw];
      print('✅ Received single object, wrapped in array');
    } else {
      print('❌ Unexpected data type: ${dataRaw.runtimeType}');
      throw Exception('Unexpected response format from server');
    }

    if (dataList.isEmpty) {
      throw Exception('No disease detected in the image');
    }

    final data = dataList[0];

    if (data is! Map<String, dynamic>) {
      throw Exception('Invalid data format in response');
    }

    return _extractDiseaseInfo(data);
  }

  /// Extract disease information from API response
  Map<String, dynamic> _extractDiseaseInfo(Map<String, dynamic> data) {
    print('🔍 Extracting disease info from: $data');

    // ✅ FIXED: Prioritize exact field names from Postman response
    final predictedDisease = _getString(data, [
      "Disease Class", // ✅ From Postman: "Disease Class": "Sugarcane__rust"
      "Predicted Disease",
      "predicted_disease",
      "predictedDisease",
      "disease_class",
      "diseaseClass",
      "class",
      "disease",
      "Disease",
    ], "Unknown Disease");

    final cause = _getString(data, [
      "Cause", // ✅ From Postman: "Cause": "Fungal disease."
      "cause",
      "Causes",
      "causes",
    ], "Unknown cause");

    final treatment = _getString(data, [
      "Treatment", // ✅ From Postman: "Treatment": "Apply fungicides..."
      "Remedy",
      "remedy",
      "treatment",
      "Remedies",
      "remedies",
      "Treatments",
      "treatments",
    ], "Consult agricultural expert");

    final confidence = _extractConfidence(data);

    if (predictedDisease == "Unknown Disease") {
      print('⚠️ Warning: Could not extract disease name from response');
      print('⚠️ Available keys: ${data.keys.toList()}');
    }

    print('✅ Scan successful!');
    print('🌱 Crop: ${_extractCropName(predictedDisease)}');
    print('🦠 Disease: ${_extractDiseaseName(predictedDisease)}');
    print('📊 Confidence: ${confidence.toStringAsFixed(1)}%');

    return {
      "crop": _extractCropName(predictedDisease),
      "disease": _extractDiseaseName(predictedDisease),
      "cause": cause,
      "treatment": treatment,
      "confidence": "${confidence.toStringAsFixed(1)}%",
      "weather": {
        "temp": "Varies by season",
        "humidity": "Monitor local conditions",
        "risk": "Check weather patterns for optimal treatment timing",
      },
      "actions": [
        treatment,
        "Monitor crops closely for disease spread",
        "Remove and destroy infected plant parts",
        "Improve air circulation around plants",
        "Seek expert advice if condition worsens",
      ],
      "products": _productsFromTreatment(treatment),
    };
  }

  String _getString(
    Map<String, dynamic> data,
    List<String> keys,
    String defaultValue,
  ) {
    for (final key in keys) {
      final value = data[key];
      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString().trim();
      }
    }
    return defaultValue;
  }

  double _extractConfidence(Map<String, dynamic> data) {
    final dynamic confidenceRaw =
        data["Confidence"] ??
        data["confidence"] ??
        data["Score"] ??
        data["score"] ??
        data["Probability"] ??
        data["probability"];

    if (confidenceRaw == null) {
      print('⚠️ Warning: No confidence value found in response');
      print('⚠️ Available keys: ${data.keys.toList()}');
      return 0.0;
    }

    if (confidenceRaw is num) {
      final value = confidenceRaw.toDouble();
      return value > 1 ? value : value * 100;
    }

    final confidenceStr = confidenceRaw.toString().replaceAll('%', '').trim();
    final parsed = double.tryParse(confidenceStr);

    if (parsed == null) {
      print('⚠️ Warning: Could not parse confidence value: $confidenceRaw');
      return 0.0;
    }

    return parsed > 1 ? parsed : parsed * 100;
  }

  Exception _handleDioException(DioException e) {
    print('❌ DioException Type: ${e.type}');
    print('❌ DioException Message: ${e.message}');
    print('❌ Response Status Code: ${e.response?.statusCode}');
    print('❌ Response Data: ${e.response?.data}');
    print('❌ Request URL: ${e.requestOptions.uri}');

    if (e.type == DioExceptionType.receiveTimeout) {
      return Exception(
        'Request timed out. The server took too long to respond. Please try again.',
      );
    }

    if (e.type == DioExceptionType.sendTimeout) {
      return Exception(
        'Upload timed out. Please check your internet connection and try again.',
      );
    }

    if (e.type == DioExceptionType.connectionTimeout) {
      return Exception(
        'Connection timed out. Please check your internet connection.',
      );
    }

    if (e.type == DioExceptionType.connectionError) {
      return Exception(
        'Cannot connect to server. Please check your internet connection.',
      );
    }

    if (e.response != null) {
      final statusCode = e.response!.statusCode;
      final body = e.response!.data;

      if (statusCode == 307) {
        final location = e.response!.headers.value('location');
        return Exception(
          'Server redirect (307) to: ${location ?? "unknown"}. '
          'Try adding ?image to the endpoint URL.',
        );
      }

      switch (statusCode) {
        case 500:
          String errorMsg = 'Server error occurred';
          if (body is Map && body['message'] != null) {
            errorMsg = body['message'];
          } else if (body is String && body.isNotEmpty) {
            errorMsg = body;
          }
          return Exception(
            'Server error: $errorMsg. The image might be corrupted or in an unsupported format.',
          );

        case 401:
          return Exception(
            'Authentication failed. Please log out and log in again.',
          );

        case 400:
          String errorMsg = 'Invalid request';
          if (body is Map &&
              (body['message'] != null || body['Message'] != null)) {
            errorMsg = body['message'] ?? body['Message'];
          }
          return Exception(errorMsg);

        case 404:
          return Exception('API endpoint not found. Please contact support.');

        case 413:
          return Exception(
            'Image file is too large. Please use a smaller image.',
          );

        case 415:
          return Exception(
            'Unsupported image format. Please use JPG, PNG, or WEBP.',
          );

        default:
          if (body is Map &&
              (body['message'] != null || body['Message'] != null)) {
            return Exception(body['message'] ?? body['Message']);
          }
          return Exception('Server returned error code: $statusCode');
      }
    }

    return Exception(
      'Network error. Please check your connection and try again.',
    );
  }

  String _extractCropName(String predictedDisease) {
    if (predictedDisease.isEmpty || predictedDisease == "Unknown Disease") {
      return 'Unknown Crop';
    }

    if (predictedDisease.contains('__')) {
      final parts = predictedDisease.split('__');
      if (parts.isNotEmpty) {
        return _capitalize(parts[0]);
      }
    }

    final onPattern = RegExp(r'\bon\s+(\w+)', caseSensitive: false);
    final match = onPattern.firstMatch(predictedDisease);
    if (match != null && match.groupCount >= 1) {
      final cropName = match.group(1);
      if (cropName != null && cropName.isNotEmpty) {
        return _capitalize(cropName);
      }
    }

    final d = predictedDisease.toLowerCase();
    final cropMap = {
      'cotton': 'Cotton',
      'grape': 'Grape',
      'maize': 'Maize',
      'tomato': 'Tomato',
      'chili': 'Chili',
      'chilli': 'Chili',
      'pepper': 'Pepper',
      'potato': 'Potato',
      'corn': 'Corn',
      'apple': 'Apple',
      'peach': 'Peach',
      'cherry': 'Cherry',
      'strawberry': 'Strawberry',
      'cassava': 'Cassava',
      'rice': 'Rice',
      'wheat': 'Wheat',
      'soybean': 'Soybean',
      'banana': 'Banana',
      'orange': 'Orange',
      'lemon': 'Lemon',
      'sugarcane': 'Sugarcane',
    };

    for (final entry in cropMap.entries) {
      if (d.contains(entry.key)) {
        return entry.value;
      }
    }

    return 'Unknown Crop';
  }

  String _extractDiseaseName(String predictedDisease) {
    if (predictedDisease.isEmpty || predictedDisease == "Unknown Disease") {
      return 'Unknown Disease';
    }

    if (predictedDisease.contains('__')) {
      final parts = predictedDisease.split('__');
      if (parts.length > 1) {
        final diseasePart = parts[1];

        if (diseasePart.toLowerCase() == 'healthy') {
          return 'Healthy';
        }

        return diseasePart
            .split('_')
            .map((word) => _capitalize(word))
            .join(' ');
      }
    }

    final onPattern = RegExp(r'\s+on\s+\w+$', caseSensitive: false);
    if (onPattern.hasMatch(predictedDisease)) {
      return predictedDisease.replaceAll(onPattern, '').trim();
    }

    return predictedDisease.trim();
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  List<Map<String, dynamic>> _productsFromTreatment(String treatment) {
    final t = treatment.toLowerCase();
    final products = <Map<String, dynamic>>[];

    if (t.contains('fungicide')) {
      products.add({"name": "Broad-Spectrum Fungicide", "price": "150 EGP"});
    }
    if (t.contains('neem')) {
      products.add({"name": "Neem Oil Organic Spray", "price": "120 EGP"});
    }
    if (t.contains('copper')) {
      products.add({"name": "Copper-Based Fungicide", "price": "180 EGP"});
    }
    if (t.contains('insecticide')) {
      products.add({"name": "Systemic Insecticide", "price": "200 EGP"});
    }
    if (t.contains('bactericide') || t.contains('antibiotic')) {
      products.add({"name": "Bacterial Control Solution", "price": "220 EGP"});
    }
    if (t.contains('sulfur')) {
      products.add({"name": "Sulfur Powder", "price": "100 EGP"});
    }

    if (products.isEmpty) {
      products.add({
        "name": "General Crop Protection Spray",
        "price": "180 EGP",
      });
      products.add({"name": "Organic Plant Booster", "price": "160 EGP"});
    } else {
      products.add({"name": "Organic Fertilizer", "price": "250 EGP"});
    }

    return products;
  }
}
