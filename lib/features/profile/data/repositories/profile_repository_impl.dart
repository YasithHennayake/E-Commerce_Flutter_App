import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/failure_from_exception.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_data_source.dart';
import '../datasources/profile_remote_data_source.dart';
import '../models/user_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remote;
  final ProfileLocalDataSource local;

  ProfileRepositoryImpl({required this.remote, required this.local});

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final username = await local.getLoggedInUsername();
      if (username == null) {
        return const Left(AuthFailure('Not logged in.'));
      }

      final cached = await local.getCachedUser();
      if (cached != null && cached.username == username) {
        return Right(cached);
      }

      final users = await remote.getUsers();
      final match = users.where((u) => u.username == username).toList();
      if (match.isEmpty) {
        throw const ServerException('Logged-in user not found in API.');
      }
      final user = match.first;
      await local.cacheUser(user);
      return Right(user);
    } catch (e) {
      return Left(failureFromException(e));
    }
  }

  @override
  Future<Either<Failure, User>> updateProfile(User user) async {
    try {
      final model = UserModel.fromEntity(user);
      await local.cacheUser(model);
      return Right(model);
    } catch (e) {
      return Left(failureFromException(e));
    }
  }
}
