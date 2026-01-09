import 'package:dio/dio.dart';
import '/core/network/dio_client.dart';
import '/core/constants/api_endpoints.dart';

class OtpRepository {
  /// Verify OTP code
  /// Returns user data with tokens on success
  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String code,
    required int type, // 1 for signup, 2 for password reset, etc.
  }) async {
    try {
      final response = await DioClient.post(
        ApiEndpoints.verifyEmail,
        data: {'email': email, 'code': code, 'type': type},
      );

      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Resend OTP code to email
  /// Returns success message
  Future<Map<String, dynamic>> resendOtp({
    required String email,
    required int type,
  }) async {
    try {
      final response = await DioClient.post(
        ApiEndpoints.resendOtp,
        data: {'email': email, 'type': type},
      );

      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    if (e.response != null) {
      final data = e.response!.data;
      if (data is Map && data['message'] != null) {
        return data['message'];
      }
      return 'Verification failed. Please try again.';
    }

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'Connection timeout. Please check your internet.';
    }

    return 'An error occurred. Please try again.';
  }
}
