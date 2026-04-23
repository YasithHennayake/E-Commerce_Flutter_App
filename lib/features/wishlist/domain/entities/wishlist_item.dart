import 'package:equatable/equatable.dart';

class WishlistItem extends Equatable {
  final int productId;
  final String title;
  final double price;
  final String image;

  const WishlistItem({
    required this.productId,
    required this.title,
    required this.price,
    required this.image,
  });

  @override
  List<Object?> get props => [productId, title, price, image];
}
