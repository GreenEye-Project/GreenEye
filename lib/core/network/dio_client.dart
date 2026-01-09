import 'package:dio/dio.dart';
import '/core/constants/api_endpoints.dart';
import 'session_manager.dart';

/// Unified DioClient for all API requests
class DioClient {
  static final Dio _dio =
      Dio(
          BaseOptions(
            baseUrl: ApiEndpoints.baseUrl,
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(
              seconds: 90,
            ), // Longer for ML processing
            sendTimeout: const Duration(seconds: 60), // Longer for file uploads
            headers: {'Accept': 'application/json'},
          ),
        )
        ..interceptors.addAll([
          // Auth interceptor
          InterceptorsWrapper(
            onRequest: (options, handler) async {
              // Add auth token for all requests except authentication endpoints
              final token = await SessionManager.accessToken;
              if (token != null && token.isNotEmpty) {
                options.headers['Authorization'] = 'Bearer $token';
              }
              handler.next(options);
            },
          ),
          // Logging interceptor
          LogInterceptor(
            requestBody: true,
            responseBody: true,
            logPrint: (obj) => print(obj),
          ),
        ]);

  static Dio get instance => _dio;

  // Authentication APIs
  static Future<Response> login(Map<String, dynamic> data) =>
      _dio.post(ApiEndpoints.login, data: data);

  static Future<Response> register(Map<String, dynamic> data) =>
      _dio.post(ApiEndpoints.register, data: data);

  static Future<Response> verifyEmail(Map<String, dynamic> data) =>
      _dio.post(ApiEndpoints.verifyEmail, data: data);

  static Future<Response> resendOtp(Map<String, dynamic> data) =>
      _dio.post(ApiEndpoints.resendOtp, data: data);

  static Future<Response> forgotPassword(Map<String, dynamic> data) =>
      _dio.post(ApiEndpoints.forgotPassword, data: data);

  static Future<Response> resetPassword(Map<String, dynamic> data) =>
      _dio.post(ApiEndpoints.resetPassword, data: data);

  static Future<Response> revokeToken() => _dio.post(ApiEndpoints.revokeToken);

  static Future<Response> refreshToken(Map<String, dynamic> data) =>
      _dio.post(ApiEndpoints.refreshToken, data: data);

  static Future<Response> changePassword(Map<String, dynamic> data) =>
      _dio.post(ApiEndpoints.changePassword, data: data);

  // User Profile APIs
  static Future<Response> getProfile() => _dio.get(ApiEndpoints.profile);

  static Future<Response> updateProfile(Map<String, dynamic> data) =>
      _dio.put(ApiEndpoints.profile, data: data);

  // Crop Disease APIs
  static Future<Response> analyzeCropDisease(
    FormData formData, {
    Options? options,
  }) {
    return _dio.post(
      ApiEndpoints.cropDisease,
      data: formData,
      options:
          options ?? Options(headers: {'Content-Type': 'multipart/form-data'}),
    );
  }

  static Future<Response> getCropDiseaseHistory({
    Map<String, dynamic>? queryParameters,
  }) => _dio.get(ApiEndpoints.cropHistory, queryParameters: queryParameters);

  // Classification API
  static Future<Response> getClassification({
    Map<String, dynamic>? queryParameters,
  }) => _dio.get(ApiEndpoints.classification, queryParameters: queryParameters);

  // Forecasting API
  static Future<Response> getForecast({
    Map<String, dynamic>? queryParameters,
  }) => _dio.get(ApiEndpoints.forecasting, queryParameters: queryParameters);

  // Crop Recommendation API
  static Future<Response> getCropRecommendation({
    Map<String, dynamic>? queryParameters,
  }) => _dio.get(
    ApiEndpoints.cropRecommendation,
    queryParameters: queryParameters,
  );

  // Generic HTTP methods (for any additional endpoints)
  static Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) => _dio.get(path, queryParameters: queryParameters);

  static Future<Response> post(String path, {dynamic data, Options? options}) =>
      _dio.post(path, data: data, options: options);

  static Future<Response> put(String path, {dynamic data, Options? options}) =>
      _dio.put(path, data: data, options: options);

  static Future<Response> delete(String path, {Options? options}) =>
      _dio.delete(path, options: options);
}
