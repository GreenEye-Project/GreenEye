import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_endpoints.dart';
import '../network/dio_client.dart';

class SessionManager {
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  /* ───────────── TOKEN STORAGE ───────────── */

  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
  }

  static Future<String?> get accessToken async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  static Future<String?> get refreshToken async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  static Future<bool> isLoggedIn() async {
    final token = await accessToken;
    return token != null && token.isNotEmpty;
  }

  /* ───────────── REFRESH TOKEN ───────────── */

  static Future<bool> refreshTokenRequest() async {
    final refreshTokenValue = await refreshToken;

    if (refreshTokenValue == null || refreshTokenValue.isEmpty) {
      return false;
    }

    try {
      final response = await DioClient.instance.get(
        ApiEndpoints.refreshToken,
        options: Options(
          headers: {'Authorization': 'Bearer $refreshTokenValue'},
        ),
      );

      final data = response.data;

      if (data == null || data['isSuccess'] != true || data['data'] == null) {
        return false;
      }

      final newAccessToken = data['data']['accessToken'];

      if (newAccessToken == null || newAccessToken.isEmpty) {
        return false;
      }

      await saveTokens(
        accessToken: newAccessToken,
        refreshToken: refreshTokenValue, // backend doesn't rotate refresh token
      );

      return true;
    } catch (_) {
      return false;
    }
  }

  /* ───────────── CLEAR SESSION ───────────── */

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
  }

  /* ───────────── LOGOUT / REVOKE ───────────── */

  static Future<void> logout() async {
    try {
      final token = await refreshToken;

      if (token != null && token.isNotEmpty) {
        await DioClient.instance.post(
          ApiEndpoints.revokeToken,
          data: {'token': token},
        );
      }
    } catch (_) {
      // Ignore revoke failure
    } finally {
      await clear();
    }
  }
}
