import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

class RemoveFromCart extends UseCase<Cart, int> {
  final CartRepository repository;
  RemoveFromCart(this.repository);

  @override
  Future<Either<Failure, Cart>> call(int productId) =>
      repository.removeItem(productId);
}
