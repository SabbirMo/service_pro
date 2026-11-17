import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  const ApiException({
    required this.message,
    this.statusCode,
    this.data,
  });

  @override
  String toString() => message;
}

class ApiErrorHandler {
  ApiErrorHandler._();

  static ApiException handle(dynamic error) {
    if (error is DioException) {
      return _handleDioException(error);
    } else if (error is ApiException) {
      return error;
    } else {
      return ApiException(
        message: 'An unexpected error occurred: ${error.toString()}',
      );
    }
  }

  static ApiException _handleDioException(DioException error) {
    String message = 'Something went wrong. Please try again.';
    final int? statusCode = error.response?.statusCode;
    final dynamic data = error.response?.data;

    if (data != null) {
      if (data is Map<String, dynamic>) {
        message = data['message']?.toString() ??
            data['msg']?.toString() ??
            data['error']?.toString() ??
            message;
      } else if (data is String && data.isNotEmpty) {
        message = data;
      }
    } else {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          message = 'Connection timeout with server';
          break;
        case DioExceptionType.sendTimeout:
          message = 'Send timeout in connection with server';
          break;
        case DioExceptionType.receiveTimeout:
          message = 'Receive timeout in connection with server';
          break;
        case DioExceptionType.badCertificate:
          message = 'Bad certificate error';
          break;
        case DioExceptionType.badResponse:
          message = _handleBadResponse(statusCode);
          break;
        case DioExceptionType.cancel:
          message = 'Request to server was cancelled';
          break;
        case DioExceptionType.connectionError:
          message =
              'No internet connection. Please check your network or server status.';
          break;
        case DioExceptionType.unknown:
        default:
          message = error.message ?? 'Unknown network error occurred';
          break;
      }
    }

    return ApiException(
      message: message,
      statusCode: statusCode,
      data: data,
    );
  }

  static String _handleBadResponse(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request. Please check your inputs.';
      case 401:
        return 'Unauthorized. Please login again.';
      case 403:
        return 'Forbidden. You do not have permission to access this resource.';
      case 404:
        return 'Not found. Requested resource was not found.';
      case 409:
        return 'Conflict occurred. Duplicate data or state conflict.';
      case 500:
        return 'Internal server error. Please try again later.';
      case 502:
        return 'Bad gateway. The server encountered a temporary error.';
      case 503:
        return 'Service unavailable. Server is temporarily overloaded.';
      default:
        return 'Received invalid status code: $statusCode';
    }
  }
}
