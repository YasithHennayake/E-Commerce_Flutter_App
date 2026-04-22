import 'package:dio/dio.dart';

import '../errors/exceptions.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final mapped = _mapToException(err);
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: mapped,
        message: mapped.toString(),
      ),
    );
  }

  Exception _mapToException(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException('Connection timed out.');
      case DioExceptionType.connectionError:
        return const NetworkException('No internet connection.');
      case DioExceptionType.cancel:
        return const NetworkException('Request was cancelled.');
      case DioExceptionType.badCertificate:
        return const NetworkException('Bad certificate.');
      case DioExceptionType.badResponse:
        final status = err.response?.statusCode;
        if (status == 401 || status == 403) {
          return const AuthException('Unauthorized. Please log in again.');
        }
        return ServerException(
          err.response?.statusMessage ?? 'Server error.',
          statusCode: status,
        );
      case DioExceptionType.unknown:
        return ServerException(err.message ?? 'Unknown error.');
    }
  }
}
