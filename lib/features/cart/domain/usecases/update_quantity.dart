import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

class UpdateQuantity extends UseCase<Cart, UpdateQuantityParams> {
  final CartRepository repository;
  UpdateQuantity(this.repository);

  @override
  Future<Either<Failure, Cart>> call(UpdateQuantityParams params) {
    return repository.updateQuantity(
      productId: params.productId,
      quantity: params.quantity,
    );
  }
}

class UpdateQuantityParams extends Equatable {
  final int productId;
  final int quantity;
  const UpdateQuantityParams({required this.productId, required this.quantity});

  @override
  List<Object?> get props => [productId, quantity];
}
