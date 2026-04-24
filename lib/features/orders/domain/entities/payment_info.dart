import 'package:equatable/equatable.dart';

enum PaymentMethod { creditCard, cashOnDelivery }

class PaymentInfo extends Equatable {
  final PaymentMethod method;
  final String? cardLast4;

  const PaymentInfo({required this.method, this.cardLast4});

  String get label {
    switch (method) {
      case PaymentMethod.creditCard:
        return cardLast4 == null ? 'Credit card' : 'Card ending in $cardLast4';
      case PaymentMethod.cashOnDelivery:
        return 'Cash on delivery';
    }
  }

  @override
  List<Object?> get props => [method, cardLast4];
}
