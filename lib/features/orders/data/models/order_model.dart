import '../../domain/entities/order.dart';
import 'address_model.dart';
import 'order_item_model.dart';
import 'payment_info_model.dart';

class OrderModel extends Order {
  const OrderModel({
    required super.id,
    required List<OrderItemModel> super.items,
    required super.subtotal,
    required super.tax,
    required super.total,
    required AddressModel super.address,
    required PaymentInfoModel super.payment,
    required super.placedAt,
    required super.status,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
          .toList(growable: false),
      subtotal: (json['subtotal'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      address:
          AddressModel.fromJson(json['address'] as Map<String, dynamic>),
      payment:
          PaymentInfoModel.fromJson(json['payment'] as Map<String, dynamic>),
      placedAt: DateTime.parse(json['placedAt'] as String),
      status: OrderStatus.values.firstWhere(
        (s) => s.name == json['status'] as String,
        orElse: () => OrderStatus.placed,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'items': items
            .map((i) => (i as OrderItemModel).toJson())
            .toList(growable: false),
        'subtotal': subtotal,
        'tax': tax,
        'total': total,
        'address': (address as AddressModel).toJson(),
        'payment': (payment as PaymentInfoModel).toJson(),
        'placedAt': placedAt.toIso8601String(),
        'status': status.name,
      };
}
