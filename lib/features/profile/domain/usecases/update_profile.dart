import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/profile_repository.dart';

class UpdateProfile extends UseCase<User, User> {
  final ProfileRepository repository;
  UpdateProfile(this.repository);

  @override
  Future<Either<Failure, User>> call(User user) =>
      repository.updateProfile(user);
}
