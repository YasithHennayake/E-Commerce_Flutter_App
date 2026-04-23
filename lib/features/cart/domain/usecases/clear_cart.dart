import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

class ClearCart extends UseCase<Cart, NoParams> {
  final CartRepository repository;
  ClearCart(this.repository);

  @override
  Future<Either<Failure, Cart>> call(NoParams params) => repository.clear();
}
