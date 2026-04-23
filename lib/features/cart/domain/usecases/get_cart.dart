import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

class GetCart extends UseCase<Cart, NoParams> {
  final CartRepository repository;
  GetCart(this.repository);

  @override
  Future<Either<Failure, Cart>> call(NoParams params) => repository.getCart();
}
