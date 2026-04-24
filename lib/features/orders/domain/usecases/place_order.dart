import 'package:dartz/dartz.dart' hide Order;
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/address.dart';
import '../entities/order.dart';
import '../entities/order_item.dart';
import '../entities/payment_info.dart';
import '../repositories/order_repository.dart';

class PlaceOrder extends UseCase<Order, PlaceOrderParams> {
  final OrderRepository repository;
  PlaceOrder(this.repository);

  @override
  Future<Either<Failure, Order>> call(PlaceOrderParams params) {
    return repository.placeOrder(
      items: params.items,
      subtotal: params.subtotal,
      tax: params.tax,
      total: params.total,
      address: params.address,
      payment: params.payment,
    );
  }
}

class PlaceOrderParams extends Equatable {
  final List<OrderItem> items;
  final double subtotal;
  final double tax;
  final double total;
  final Address address;
  final PaymentInfo payment;

  const PlaceOrderParams({
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.address,
    required this.payment,
  });

  @override
  List<Object?> get props => [items, subtotal, tax, total, address, payment];
}
