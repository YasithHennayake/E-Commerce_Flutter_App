import 'package:equatable/equatable.dart';

class OrderItem extends Equatable {
  final int productId;
  final String title;
  final double price;
  final String image;
  final int quantity;

  const OrderItem({
    required this.productId,
    required this.title,
    required this.price,
    required this.image,
    required this.quantity,
  });

  double get lineTotal => price * quantity;

  @override
  List<Object?> get props => [productId, title, price, image, quantity];
}
