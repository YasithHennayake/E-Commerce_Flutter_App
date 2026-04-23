import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/add_to_cart.dart' as uc;
import '../../domain/usecases/clear_cart.dart' as uc;
import '../../domain/usecases/get_cart.dart' as uc;
import '../../domain/usecases/remove_from_cart.dart' as uc;
import '../../domain/usecases/update_quantity.dart' as uc;
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final uc.GetCart getCartUseCase;
  final uc.AddToCart addToCartUseCase;
  final uc.RemoveFromCart removeFromCartUseCase;
  final uc.UpdateQuantity updateQuantityUseCase;
  final uc.ClearCart clearCartUseCase;

  CartBloc({
    required this.getCartUseCase,
    required this.addToCartUseCase,
    required this.removeFromCartUseCase,
    required this.updateQuantityUseCase,
    required this.clearCartUseCase,
  }) : super(const CartState()) {
    on<LoadCart>(_onLoad);
    on<AddToCart>(_onAdd);
    on<RemoveFromCart>(_onRemove);
    on<UpdateQuantity>(_onUpdate);
    on<ClearCart>(_onClear);
  }

  Future<void> _onLoad(LoadCart event, Emitter<CartState> emit) async {
    emit(state.copyWith(status: CartStatus.loading));
    final result = await getCartUseCase(const NoParams());
    result.fold(
      (f) => emit(state.copyWith(status: CartStatus.failure, failure: f)),
      (cart) => emit(state.copyWith(
        status: CartStatus.success,
        cart: cart,
        clearFailure: true,
      )),
    );
  }

  Future<void> _onAdd(AddToCart event, Emitter<CartState> emit) async {
    final result = await addToCartUseCase(event.item);
    result.fold(
      (f) => emit(state.copyWith(status: CartStatus.failure, failure: f)),
      (cart) => emit(state.copyWith(
        status: CartStatus.success,
        cart: cart,
        clearFailure: true,
      )),
    );
  }

  Future<void> _onRemove(RemoveFromCart event, Emitter<CartState> emit) async {
    final result = await removeFromCartUseCase(event.productId);
    result.fold(
      (f) => emit(state.copyWith(status: CartStatus.failure, failure: f)),
      (cart) => emit(state.copyWith(
        status: CartStatus.success,
        cart: cart,
        clearFailure: true,
      )),
    );
  }

  Future<void> _onUpdate(UpdateQuantity event, Emitter<CartState> emit) async {
    final result = await updateQuantityUseCase(
      uc.UpdateQuantityParams(
        productId: event.productId,
        quantity: event.quantity,
      ),
    );
    result.fold(
      (f) => emit(state.copyWith(status: CartStatus.failure, failure: f)),
      (cart) => emit(state.copyWith(
        status: CartStatus.success,
        cart: cart,
        clearFailure: true,
      )),
    );
  }

  Future<void> _onClear(ClearCart event, Emitter<CartState> emit) async {
    final result = await clearCartUseCase(const NoParams());
    result.fold(
      (f) => emit(state.copyWith(status: CartStatus.failure, failure: f)),
      (cart) => emit(state.copyWith(
        status: CartStatus.success,
        cart: cart,
        clearFailure: true,
      )),
    );
  }
}
