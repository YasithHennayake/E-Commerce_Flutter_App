import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/failure_from_exception.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remote;

  ProductRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    try {
      final products = await remote.getProducts();
      return Right(products);
    } catch (e) {
      return Left(failureFromException(e));
    }
  }

  @override
  Future<Either<Failure, Product>> getProductById(int id) async {
    try {
      final product = await remote.getProductById(id);
      return Right(product);
    } catch (e) {
      return Left(failureFromException(e));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getCategories() async {
    try {
      final categories = await remote.getCategories();
      return Right(categories);
    } catch (e) {
      return Left(failureFromException(e));
    }
  }
}
