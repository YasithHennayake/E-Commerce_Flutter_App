import 'package:dartz/dartz.dart' hide Order;

import '../../../../core/errors/failures.dart';
import '../entities/address.dart';
import '../entities/order.dart';
import '../entities/order_item.dart';
import '../entities/payment_info.dart';

abstract class OrderRepository {
  Future<Either<Failure, Order>> placeOrder({
    required List<OrderItem> items,
    required double subtotal,
    required double tax,
    required double total,
    required Address address,
    required PaymentInfo payment,
  });

  Future<Either<Failure, List<Order>>> getAll();
}
