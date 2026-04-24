import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class ProfileRepository {
  Future<Either<Failure, User>> getCurrentUser();
  Future<Either<Failure, User>> updateProfile(User user);
}
