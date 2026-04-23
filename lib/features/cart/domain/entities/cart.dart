import 'package:equatable/equatable.dart';

import 'cart_item.dart';

class Cart extends Equatable {
  static const double taxRate = 0.10;

  final List<CartItem> items;

  const Cart({this.items = const []});

  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;

  int get count => items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal =>
      items.fold(0, (sum, item) => sum + item.lineTotal);

  double get tax => subtotal * taxRate;

  double get total => subtotal + tax;

  @override
  List<Object?> get props => [items];
}
