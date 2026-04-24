import 'package:dartz/dartz.dart' hide Order;

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/order.dart';
import '../repositories/order_repository.dart';

class GetOrders extends UseCase<List<Order>, NoParams> {
  final OrderRepository repository;
  GetOrders(this.repository);

  @override
  Future<Either<Failure, List<Order>>> call(NoParams params) =>
      repository.getAll();
}
