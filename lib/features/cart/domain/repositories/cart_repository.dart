import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/cart.dart';
import '../entities/cart_item.dart';

abstract class CartRepository {
  Future<Either<Failure, Cart>> getCart();
  Future<Either<Failure, Cart>> addItem(CartItem item);
  Future<Either<Failure, Cart>> updateQuantity({
    required int productId,
    required int quantity,
  });
  Future<Either<Failure, Cart>> removeItem(int productId);
  Future<Either<Failure, Cart>> clear();
}
