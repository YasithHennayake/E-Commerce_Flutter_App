import 'package:dartz/dartz.dart' hide Order;

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/failure_from_exception.dart';
import '../../domain/entities/address.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/order_item.dart';
import '../../domain/entities/payment_info.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_local_data_source.dart';
import '../datasources/order_remote_data_source.dart';
import '../models/address_model.dart';
import '../models/order_item_model.dart';
import '../models/order_model.dart';
import '../models/payment_info_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remote;
  final OrderLocalDataSource local;

  OrderRepositoryImpl({required this.remote, required this.local});

  @override
  Future<Either<Failure, Order>> placeOrder({
    required List<OrderItem> items,
    required double subtotal,
    required double tax,
    required double total,
    required Address address,
    required PaymentInfo payment,
  }) async {
    try {
      final remoteId = await remote.submitCart(userId: 1, items: items);
      final model = OrderModel(
        id: remoteId,
        items: items.map(OrderItemModel.fromEntity).toList(growable: false),
        subtotal: subtotal,
        tax: tax,
        total: total,
        address: AddressModel.fromEntity(address),
        payment: PaymentInfoModel.fromEntity(payment),
        placedAt: DateTime.now(),
        status: OrderStatus.placed,
      );
      await local.put(model);
      return Right(model);
    } catch (e) {
      return Left(failureFromException(e));
    }
  }

  @override
  Future<Either<Failure, List<Order>>> getAll() async {
    try {
      final orders = await local.getAll();
      return Right(orders);
    } catch (e) {
      return Left(failureFromException(e));
    }
  }
}
