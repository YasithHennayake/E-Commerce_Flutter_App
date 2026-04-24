import '../../domain/entities/order_item.dart';

class OrderItemModel extends OrderItem {
  const OrderItemModel({
    required super.productId,
    required super.title,
    required super.price,
    required super.image,
    required super.quantity,
  });

  factory OrderItemModel.fromEntity(OrderItem i) => OrderItemModel(
        productId: i.productId,
        title: i.title,
        price: i.price,
        image: i.image,
        quantity: i.quantity,
      );

  factory OrderItemModel.fromJson(Map<String, dynamic> json) => OrderItemModel(
        productId: json['productId'] as int,
        title: json['title'] as String,
        price: (json['price'] as num).toDouble(),
        image: json['image'] as String,
        quantity: json['quantity'] as int,
      );

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'title': title,
        'price': price,
        'image': image,
        'quantity': quantity,
      };
}
