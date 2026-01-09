import 'package:dio/dio.dart';
import '/core/network/dio_client.dart';
import '/core/constants/api_endpoints.dart';
import '/core/network/session_manager.dart';

class AuthRepository {
  /// ───────────── REGISTER ─────────────
  Future<void> register({
    required String name,
    required String phone,
    required String email,
    required String address,
    required String password,
    required String confirmPassword,
    required int role,
  }) async {
    try {
      final response = await DioClient.post(
        ApiEndpoints.register,
        data: {
          "name": name,
          "phone": phone,
          "email": email,
          "address": address,
          "password": password,
          "confirmPassword": confirmPassword,
          "roles": role,
        },
      );

      final body = response.data;
      if (body["isSuccess"] != true) {
        throw Exception(body["message"] ?? "Registration failed");
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// ───────────── LOGIN ─────────────
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    try {
      final response = await DioClient.post(
        ApiEndpoints.login,
        data: {"email": email, "password": password, "rememberMe": rememberMe},
      );

      final body = response.data;

      if (body["isSuccess"] != true) {
        throw Exception(body["message"] ?? "Login failed");
      }

      final data = body["data"];
      if (data == null) {
        throw Exception("Invalid server response");
      }

      final accessToken = data["accessToken"];
      final refreshToken = data["refreshToken"];

      if (accessToken == null || accessToken.isEmpty) {
        throw Exception("Authentication token missing");
      }

      // Save tokens to SessionManager
      await SessionManager.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken ?? '',
      );

      print('✅ Login successful - Token saved');
      print('🔑 Access Token: ${accessToken.substring(0, 20)}...');

      return data;
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  /// ───────────── FORGOT PASSWORD ─────────────
  Future<String> forgotPassword({required String email}) async {
    try {
      final response = await DioClient.instance.post(
        ApiEndpoints.forgotPassword,
        queryParameters: {"email": email},
      );

      final body = response.data;

      if (body["isSuccess"] != true) {
        throw Exception(body["message"] ?? "Request failed");
      }

      return body["message"] ?? body["data"] ?? "Reset code sent successfully";
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  /// ───────────── RESET PASSWORD ─────────────
  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    try {
      final response = await DioClient.post(
        ApiEndpoints.resetPassword,
        data: {"email": email, "password": newPassword},
      );

      final body = response.data;
      if (body["isSuccess"] != true) {
        throw Exception(body["message"] ?? "Password reset failed");
      }
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  /// ───────────── ERROR HANDLER ─────────────
  String _handleError(DioException e) {
    if (e.response != null) {
      final data = e.response!.data;
      if (data is Map && data['message'] != null) {
        return data['message'];
      }
      return 'Request failed. Please try again.';
    }

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'Connection timeout. Please check your internet.';
    }

    if (e.type == DioExceptionType.connectionError) {
      return 'No internet connection. Please check your network.';
    }

    return 'An error occurred. Please try again.';
  }
}
