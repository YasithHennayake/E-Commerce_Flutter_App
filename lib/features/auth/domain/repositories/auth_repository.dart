import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/auth_token.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthToken>> login({
    required String username,
    required String password,
  });

  Future<Either<Failure, AuthToken?>> getCachedToken();

  Future<Either<Failure, Unit>> logout();
}
