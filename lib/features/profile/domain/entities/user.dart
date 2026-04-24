import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String username;
  final String phone;
  final String city;
  final String street;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.username,
    required this.phone,
    required this.city,
    required this.street,
  });

  String get fullName {
    final cleaned = '$firstName $lastName'.trim();
    return cleaned.isEmpty ? username : cleaned;
  }

  String get initials {
    final first = firstName.isNotEmpty ? firstName[0] : '';
    final last = lastName.isNotEmpty ? lastName[0] : '';
    final combined = (first + last).toUpperCase();
    if (combined.isNotEmpty) return combined;
    return username.isNotEmpty ? username[0].toUpperCase() : '?';
  }

  User copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? city,
    String? street,
  }) {
    return User(
      id: id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      username: username,
      phone: phone ?? this.phone,
      city: city ?? this.city,
      street: street ?? this.street,
    );
  }

  @override
  List<Object?> get props =>
      [id, firstName, lastName, email, username, phone, city, street];
}
