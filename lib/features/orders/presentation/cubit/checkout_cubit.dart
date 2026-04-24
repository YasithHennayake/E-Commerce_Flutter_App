import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/address.dart';
import '../../domain/entities/order_item.dart';
import '../../domain/entities/payment_info.dart';
import '../../domain/usecases/place_order.dart';
import 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final PlaceOrder placeOrderUseCase;

  CheckoutCubit({required this.placeOrderUseCase})
      : super(const CheckoutState());

  void goToStep(int step) {
    if (step < 0 || step > 2) return;
    emit(state.copyWith(step: step));
  }

  void setAddress(Address address) {
    emit(state.copyWith(address: address, step: 1));
  }

  void setPayment(PaymentInfo payment) {
    emit(state.copyWith(payment: payment, step: 2));
  }

  Future<void> placeOrder({
    required List<OrderItem> items,
    required double subtotal,
    required double tax,
    required double total,
  }) async {
    if (!state.canReview) return;
    emit(state.copyWith(status: CheckoutStatus.placing, clearFailure: true));
    final result = await placeOrderUseCase(
      PlaceOrderParams(
        items: items,
        subtotal: subtotal,
        tax: tax,
        total: total,
        address: state.address!,
        payment: state.payment!,
      ),
    );
    result.fold(
      (f) => emit(state.copyWith(status: CheckoutStatus.failure, failure: f)),
      (order) => emit(state.copyWith(
        status: CheckoutStatus.success,
        placedOrder: order,
        clearFailure: true,
      )),
    );
  }

  void reset() => emit(const CheckoutState());
}
