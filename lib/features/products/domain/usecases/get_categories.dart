import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/product_repository.dart';

class GetCategories extends UseCase<List<String>, NoParams> {
  final ProductRepository repository;
  GetCategories(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(NoParams params) =>
      repository.getCategories();
}
