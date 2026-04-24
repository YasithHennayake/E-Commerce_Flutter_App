import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/address.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/payment_info.dart';

enum CheckoutStatus { editing, placing, success, failure }

class CheckoutState extends Equatable {
  final int step;
  final Address? address;
  final PaymentInfo? payment;
  final CheckoutStatus status;
  final Order? placedOrder;
  final Failure? failure;

  const CheckoutState({
    this.step = 0,
    this.address,
    this.payment,
    this.status = CheckoutStatus.editing,
    this.placedOrder,
    this.failure,
  });

  bool get canReview => address != null && payment != null;

  CheckoutState copyWith({
    int? step,
    Address? address,
    PaymentInfo? payment,
    CheckoutStatus? status,
    Order? placedOrder,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return CheckoutState(
      step: step ?? this.step,
      address: address ?? this.address,
      payment: payment ?? this.payment,
      status: status ?? this.status,
      placedOrder: placedOrder ?? this.placedOrder,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }

  @override
  List<Object?> get props =>
      [step, address, payment, status, placedOrder, failure];
}
