import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductById extends UseCase<Product, int> {
  final ProductRepository repository;
  GetProductById(this.repository);

  @override
  Future<Either<Failure, Product>> call(int id) =>
      repository.getProductById(id);
}
