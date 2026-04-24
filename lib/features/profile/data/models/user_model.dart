import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.username,
    required super.phone,
    required super.city,
    required super.street,
  });

  factory UserModel.fromEntity(User u) => UserModel(
        id: u.id,
        firstName: u.firstName,
        lastName: u.lastName,
        email: u.email,
        username: u.username,
        phone: u.phone,
        city: u.city,
        street: u.street,
      );

  factory UserModel.fromApiJson(Map<String, dynamic> json) {
    final name = json['name'] as Map<String, dynamic>? ?? const {};
    final address = json['address'] as Map<String, dynamic>? ?? const {};
    return UserModel(
      id: json['id'] as int,
      firstName: (name['firstname'] as String?) ?? '',
      lastName: (name['lastname'] as String?) ?? '',
      email: (json['email'] as String?) ?? '',
      username: (json['username'] as String?) ?? '',
      phone: (json['phone'] as String?) ?? '',
      city: (address['city'] as String?) ?? '',
      street: (address['street'] as String?) ?? '',
    );
  }

  factory UserModel.fromCacheJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as int,
        firstName: json['firstName'] as String,
        lastName: json['lastName'] as String,
        email: json['email'] as String,
        username: json['username'] as String,
        phone: json['phone'] as String,
        city: json['city'] as String,
        street: json['street'] as String,
      );

  Map<String, dynamic> toCacheJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'username': username,
        'phone': phone,
        'city': city,
        'street': street,
      };
}
