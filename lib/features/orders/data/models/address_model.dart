import '../../domain/entities/address.dart';

class AddressModel extends Address {
  const AddressModel({
    required super.fullName,
    required super.street,
    required super.city,
    required super.zip,
    required super.country,
    required super.phone,
  });

  factory AddressModel.fromEntity(Address a) => AddressModel(
        fullName: a.fullName,
        street: a.street,
        city: a.city,
        zip: a.zip,
        country: a.country,
        phone: a.phone,
      );

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        fullName: json['fullName'] as String,
        street: json['street'] as String,
        city: json['city'] as String,
        zip: json['zip'] as String,
        country: json['country'] as String,
        phone: json['phone'] as String,
      );

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'street': street,
        'city': city,
        'zip': zip,
        'country': country,
        'phone': phone,
      };
}
