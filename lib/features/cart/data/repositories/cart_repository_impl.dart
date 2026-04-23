import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/failure_from_exception.dart';
import '../../domain/entities/cart.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_local_data_source.dart';
import '../models/cart_item_model.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource local;

  CartRepositoryImpl(this.local);

  Future<Cart> _readCart() async {
    final items = await local.getAll();
    return Cart(items: items);
  }

  @override
  Future<Either<Failure, Cart>> getCart() async {
    try {
      return Right(await _readCart());
    } catch (e) {
      return Left(failureFromException(e));
    }
  }

  @override
  Future<Either<Failure, Cart>> addItem(CartItem item) async {
    try {
      final existing = await local.getAll();
      final match = existing.cast<CartItemModel?>().firstWhere(
            (e) => e?.productId == item.productId,
            orElse: () => null,
          );
      final model = CartItemModel.fromEntity(item);
      if (match != null) {
        await local.put(match.copyWith(quantity: match.quantity + item.quantity));
      } else {
        await local.put(model);
      }
      return Right(await _readCart());
    } catch (e) {
      return Left(failureFromException(e));
    }
  }

  @override
  Future<Either<Failure, Cart>> updateQuantity({
    required int productId,
    required int quantity,
  }) async {
    try {
      if (quantity <= 0) {
        await local.delete(productId);
      } else {
        final existing = await local.getAll();
        final match = existing.cast<CartItemModel?>().firstWhere(
              (e) => e?.productId == productId,
              orElse: () => null,
            );
        if (match != null) {
          await local.put(match.copyWith(quantity: quantity));
        }
      }
      return Right(await _readCart());
    } catch (e) {
      return Left(failureFromException(e));
    }
  }

  @override
  Future<Either<Failure, Cart>> removeItem(int productId) async {
    try {
      await local.delete(productId);
      return Right(await _readCart());
    } catch (e) {
      return Left(failureFromException(e));
    }
  }

  @override
  Future<Either<Failure, Cart>> clear() async {
    try {
      await local.clear();
      return Right(await _readCart());
    } catch (e) {
      return Left(failureFromException(e));
    }
  }
}
