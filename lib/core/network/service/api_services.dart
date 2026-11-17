import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_pro/core/network/dio_client/dio_client.dart';
import 'package:service_pro/core/network/error/api_error_handler.dart';

class ApiServices {
  ApiServices();

  Dio _getDio(bool requireAuth) {
    return requireAuth ? DioClient.instance : DioClient.instanceWithoutAuth;
  }

  // Common error handler and API response handler
  Future<Response<T>> _request<T>(
    Future<Response<T>> Function(Dio dio) request, {
    bool requireAuth = true,
  }) async {
    try {
      final dio = _getDio(requireAuth);
      return await request(dio);
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  /// GET request
  Future<Response<T>> get<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    bool requireAuth = true,
  }) async {
    return _request<T>(
      (dio) => dio.get<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      ),
      requireAuth: requireAuth,
    );
  }

  /// POST request
  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool requireAuth = true,
  }) async {
    return _request<T>(
      (dio) => dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ),
      requireAuth: requireAuth,
    );
  }

  /// PUT request
  Future<Response<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool requireAuth = true,
  }) async {
    return _request<T>(
      (dio) => dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ),
      requireAuth: requireAuth,
    );
  }

  /// PATCH request
  Future<Response<T>> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool requireAuth = true,
  }) async {
    return _request<T>(
      (dio) => dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ),
      requireAuth: requireAuth,
    );
  }

  /// DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool requireAuth = true,
  }) async {
    return _request<T>(
      (dio) => dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
      requireAuth: requireAuth,
    );
  }
}

final apiServicesProvider = Provider<ApiServices>((ref) {
  return ApiServices();
});
