import 'package:dio/dio.dart';

import '../errors/exceptions.dart';
import '../errors/failures.dart';

Failure failureFromException(Object error) {
  final unwrapped = error is DioException ? (error.error ?? error) : error;
  if (unwrapped is AuthException) return AuthFailure(unwrapped.message);
  if (unwrapped is NetworkException) return NetworkFailure(unwrapped.message);
  if (unwrapped is ServerException) {
    return ServerFailure(unwrapped.message, statusCode: unwrapped.statusCode);
  }
  if (unwrapped is CacheException) return CacheFailure(unwrapped.message);
  return UnknownFailure(unwrapped.toString());
}
