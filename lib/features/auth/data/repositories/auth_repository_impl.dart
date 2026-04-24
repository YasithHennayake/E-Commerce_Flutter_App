import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/failure_from_exception.dart';
import '../../domain/entities/auth_token.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  final AuthLocalDataSource local;

  AuthRepositoryImpl({required this.remote, required this.local});

  @override
  Future<Either<Failure, AuthToken>> login({
    required String username,
    required String password,
  }) async {
    try {
      final model = await remote.login(username: username, password: password);
      await local.cacheToken(model);
      await local.cacheUsername(username);
      return Right(model);
    } catch (e) {
      return Left(failureFromException(e));
    }
  }

  @override
  Future<Either<Failure, AuthToken?>> getCachedToken() async {
    try {
      final model = await local.getCachedToken();
      return Right(model);
    } catch (e) {
      return Left(failureFromException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await local.clearToken();
      return const Right(unit);
    } catch (e) {
      return Left(failureFromException(e));
    }
  }
}
