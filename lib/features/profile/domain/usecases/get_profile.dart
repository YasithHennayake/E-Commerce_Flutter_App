import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/profile_repository.dart';

class GetProfile extends UseCase<User, NoParams> {
  final ProfileRepository repository;
  GetProfile(this.repository);

  @override
  Future<Either<Failure, User>> call(NoParams params) =>
      repository.getCurrentUser();
}
