import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:service_pro/core/base_url/api_base_url.dart';
import 'package:service_pro/core/network/api_endpoint/api_end_point.dart';
import 'package:service_pro/core/utils/token_storage.dart';

class AuthInterceptor extends Interceptor {
  final Dio _dio;

  Future<String?>? _refreshFuture;

  AuthInterceptor(this._dio);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final token = await TokenStorage.getAccessToken();

      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }

      handler.next(options);
    } catch (e, stackTrace) {
      log('Failed to read access token', error: e, stackTrace: stackTrace);
      handler.reject(DioException(requestOptions: options, error: e));
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final request = err.requestOptions;
    final path = request.path;

    final isAuthEndpoint =
        path.contains(ApiEndPoints.logout) ||
        path.contains(ApiEndPoints.refreshToken) ||
        path.contains(ApiEndPoints.login) ||
        path.contains(ApiEndPoints.register);

    // If not a 401, or already retried, or is an auth endpoint, don't attempt refresh
    if (err.response?.statusCode != 401 ||
        request.extra['auth_retry'] == true ||
        isAuthEndpoint) {
      handler.next(err);
      return;
    }

    try {
      // Reuse ongoing refresh request or create a new one
      final refreshFuture = _refreshFuture ??= _getNewToken();
      final newToken = await refreshFuture;

      if (identical(_refreshFuture, refreshFuture)) {
        _refreshFuture = null;
      }

      // If refresh failed to produce a valid token
      if (newToken == null || newToken.isEmpty) {
        await TokenStorage.clearTokens();
        handler.next(err);
        return;
      }

      // Mark request as retried and set the fresh authorization header
      request.extra['auth_retry'] = true;
      request.headers['Authorization'] = 'Bearer $newToken';

      // Retry original request
      final response = await _dio.fetch<dynamic>(request);
      handler.resolve(response);
    } catch (e, stackTrace) {
      _refreshFuture = null;

      log(
        'Token refresh or request retry failed',
        error: e,
        stackTrace: stackTrace,
      );

      handler.next(err);
    }
  }

  Future<String?> _getNewToken() async {
    try {
      final refreshToken = await TokenStorage.getRefreshToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        return null;
      }

      // Separate clean Dio instance without interceptors for refreshing token
      final refreshDio = Dio(
        BaseOptions(
          baseUrl: ApiBaseUrl.baseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          headers: const {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      final response = await refreshDio.post<dynamic>(
        ApiEndPoints.refreshToken,
        data: {'refresh': refreshToken, 'refreshToken': refreshToken},
      );

      final data = response.data;

      if (response.statusCode != 200 || data is! Map<String, dynamic>) {
        return null;
      }

      // Handle common response formats: {access: ...} or {accessToken: ...} or {token: ...}
      final accessToken =
          data['access'] ??
          data['accessToken'] ??
          data['token'] ??
          (data['data'] is Map<String, dynamic>
              ? data['data']['accessToken'] ?? data['data']['token']
              : null);

      if (accessToken is! String || accessToken.isEmpty) {
        return null;
      }

      await TokenStorage.saveAccessToken(accessToken);

      // Handle optional new refresh token rotation
      final newRefreshToken =
          data['refresh'] ??
          data['refreshToken'] ??
          (data['data'] is Map<String, dynamic>
              ? data['data']['refreshToken']
              : null);

      if (newRefreshToken is String && newRefreshToken.isNotEmpty) {
        await TokenStorage.saveRefreshToken(newRefreshToken);
      }

      return accessToken;
    } on DioException catch (e, stackTrace) {
      log(
        'Refresh API failed: ${e.response?.statusCode}',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    } catch (e, stackTrace) {
      log('Unexpected token refresh error', error: e, stackTrace: stackTrace);
      return null;
    }
  }
}
