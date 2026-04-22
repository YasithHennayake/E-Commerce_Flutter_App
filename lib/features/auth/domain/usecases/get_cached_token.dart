import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/auth_token.dart';
import '../repositories/auth_repository.dart';

class GetCachedToken extends UseCase<AuthToken?, NoParams> {
  final AuthRepository repository;
  GetCachedToken(this.repository);

  @override
  Future<Either<Failure, AuthToken?>> call(NoParams params) {
    return repository.getCachedToken();
  }
}
