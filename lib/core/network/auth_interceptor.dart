import 'package:dio/dio.dart';
import './session_manager.dart';
import './dio_client.dart';
import '/core/constants/api_endpoints.dart';

class AuthInterceptor extends Interceptor {
  bool _isRefreshing = false;
  final List<_RetryRequest> _queue = [];

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    print('📤 Request to: ${options.path}');

    // Refresh endpoint → use refresh token
    if (options.path == ApiEndpoints.refreshToken) {
      final refreshToken = await SessionManager.refreshToken;
      if (refreshToken != null && refreshToken.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $refreshToken';
        print('🔄 Using refresh token');
      }
      return handler.next(options);
    }

    // Revoke endpoint → no token
    if (options.path == ApiEndpoints.revokeToken) {
      print('🚪 Revoke token request - no auth needed');
      return handler.next(options);
    }

    // Login/Register endpoints → no token needed
    if (options.path == ApiEndpoints.login ||
        options.path == ApiEndpoints.register) {
      print('🔓 Auth endpoint - no token needed');
      return handler.next(options);
    }

    // All other endpoints → access token
    final token = await SessionManager.accessToken;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
      print('🔐 Token attached: ${token.substring(0, 20)}...');
    } else {
      print('⚠️ No token found for ${options.path}');
    }

    handler.next(options);
  }

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    print(
      '✅ Response from ${response.requestOptions.path}: ${response.statusCode}',
    );
    handler.next(response);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    print('❌ Error on ${err.requestOptions.path}: ${err.response?.statusCode}');

    // Only handle 401
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    print('🔒 Got 401 - attempting token refresh');

    // If refresh itself failed → logout
    if (err.requestOptions.path == ApiEndpoints.refreshToken) {
      print('❌ Refresh token expired - logging out');
      await SessionManager.logout();
      return handler.next(err);
    }

    // If already refreshing → queue request
    if (_isRefreshing) {
      print('⏳ Already refreshing - queueing request');
      _queue.add(_RetryRequest(err.requestOptions, handler));
      return;
    }

    _isRefreshing = true;

    try {
      print('🔄 Attempting to refresh token...');
      final refreshed = await SessionManager.refreshTokenRequest();

      if (!refreshed) {
        print('❌ Token refresh failed - logging out');
        await SessionManager.logout();
        _rejectAll(err);
        return handler.next(err);
      }

      print('✅ Token refreshed successfully');

      // Retry original request
      await _retry(err.requestOptions, handler);

      // Retry queued requests
      print('🔄 Retrying ${_queue.length} queued requests');
      for (final q in _queue) {
        await _retry(q.options, q.handler);
      }
      _queue.clear();
    } catch (e) {
      print('❌ Refresh process failed: $e');
      await SessionManager.logout();
      _rejectAll(err);
      handler.next(err);
    } finally {
      _isRefreshing = false;
    }
  }

  Future<void> _retry(
    RequestOptions requestOptions,
    ErrorInterceptorHandler handler,
  ) async {
    try {
      final token = await SessionManager.accessToken;

      final options = requestOptions.copyWith(
        headers: {
          ...requestOptions.headers,
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      print('🔁 Retrying request to ${options.path}');
      final response = await DioClient.instance.fetch(options);
      handler.resolve(response);
    } catch (e) {
      print('❌ Retry failed: $e');
      handler.reject(DioException(requestOptions: requestOptions, error: e));
    }
  }

  void _rejectAll(DioException err) {
    for (final q in _queue) {
      q.handler.next(err);
    }
    _queue.clear();
  }
}

class _RetryRequest {
  final RequestOptions options;
  final ErrorInterceptorHandler handler;

  _RetryRequest(this.options, this.handler);
}
