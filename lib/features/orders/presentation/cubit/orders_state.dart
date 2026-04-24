import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/order.dart';

enum OrdersStatus { initial, loading, success, failure }

class OrdersState extends Equatable {
  final OrdersStatus status;
  final List<Order> orders;
  final Failure? failure;

  const OrdersState({
    this.status = OrdersStatus.initial,
    this.orders = const [],
    this.failure,
  });

  OrdersState copyWith({
    OrdersStatus? status,
    List<Order>? orders,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return OrdersState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }

  @override
  List<Object?> get props => [status, orders, failure];
}
