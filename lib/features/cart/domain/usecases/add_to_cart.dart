import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/cart.dart';
import '../entities/cart_item.dart';
import '../repositories/cart_repository.dart';

class AddToCart extends UseCase<Cart, CartItem> {
  final CartRepository repository;
  AddToCart(this.repository);

  @override
  Future<Either<Failure, Cart>> call(CartItem item) =>
      repository.addItem(item);
}
