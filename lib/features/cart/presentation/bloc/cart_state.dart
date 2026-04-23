import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/cart.dart';

enum CartStatus { initial, loading, success, failure }

class CartState extends Equatable {
  final CartStatus status;
  final Cart cart;
  final Failure? failure;

  const CartState({
    this.status = CartStatus.initial,
    this.cart = const Cart(),
    this.failure,
  });

  CartState copyWith({
    CartStatus? status,
    Cart? cart,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return CartState(
      status: status ?? this.status,
      cart: cart ?? this.cart,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }

  @override
  List<Object?> get props => [status, cart, failure];
}
