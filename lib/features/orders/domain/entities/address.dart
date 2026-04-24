import 'package:equatable/equatable.dart';

class Address extends Equatable {
  final String fullName;
  final String street;
  final String city;
  final String zip;
  final String country;
  final String phone;

  const Address({
    required this.fullName,
    required this.street,
    required this.city,
    required this.zip,
    required this.country,
    required this.phone,
  });

  String get formatted => '$street, $city $zip, $country';

  @override
  List<Object?> get props => [fullName, street, city, zip, country, phone];
}
