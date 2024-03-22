import 'package:mongo_dart/mongo_dart.dart';

class User {
  ObjectId? id;
  String username;
  String password;
  String email;
  String? phone;
  String? shippingAddress;
  String? billingAddress;
  Map<String, dynamic>? preferences;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    this.phone,
    this.shippingAddress,
    this.billingAddress,
    this.preferences,
  });

  // Convert a MongoDB document to a User object
  factory User.fromMap(Map<String, dynamic> map) => User(
        id: map['_id'],
        username: map['username'],
        password: map['password'],
        email: map['email'],
        phone: map['phone'] as String?,
        shippingAddress: map['shippingAddress'] as String?,
        billingAddress: map['billingAddress'] as String?,
        preferences: map['preferences'] as Map<String, dynamic>?,
      );

  // Convert a User object to a MongoDB document
  Map<String, dynamic> toMap() => {
        '_id': id,
        'username': username,
        'password': password,
        'email': email,
        'phone': phone,
        'shippingAddress': shippingAddress,
        'billingAddress': billingAddress,
        'preferences': preferences,
      };
}
