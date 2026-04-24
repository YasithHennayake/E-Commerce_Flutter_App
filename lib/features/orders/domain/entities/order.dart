import 'package:equatable/equatable.dart';

import 'address.dart';
import 'order_item.dart';
import 'payment_info.dart';

enum OrderStatus { placed, shipped, delivered }

class Order extends Equatable {
  final String id;
  final List<OrderItem> items;
  final double subtotal;
  final double tax;
  final double total;
  final Address address;
  final PaymentInfo payment;
  final DateTime placedAt;
  final OrderStatus status;

  const Order({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.address,
    required this.payment,
    required this.placedAt,
    required this.status,
  });

  int get itemCount => items.fold(0, (sum, i) => sum + i.quantity);

  @override
  List<Object?> get props => [
        id,
        items,
        subtotal,
        tax,
        total,
        address,
        payment,
        placedAt,
        status,
      ];
}
