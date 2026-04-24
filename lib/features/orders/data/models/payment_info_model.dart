import '../../domain/entities/payment_info.dart';

class PaymentInfoModel extends PaymentInfo {
  const PaymentInfoModel({required super.method, super.cardLast4});

  factory PaymentInfoModel.fromEntity(PaymentInfo p) =>
      PaymentInfoModel(method: p.method, cardLast4: p.cardLast4);

  factory PaymentInfoModel.fromJson(Map<String, dynamic> json) {
    return PaymentInfoModel(
      method: PaymentMethod.values.firstWhere(
        (m) => m.name == json['method'] as String,
        orElse: () => PaymentMethod.cashOnDelivery,
      ),
      cardLast4: json['cardLast4'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'method': method.name,
        'cardLast4': cardLast4,
      };
}
