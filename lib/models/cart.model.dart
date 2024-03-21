import 'package:mongo_dart/mongo_dart.dart';

class Cart {
  ObjectId? id;
  ObjectId? user;
  List<Map<String, dynamic>> products;

  Cart({
    required this.id,
    required this.user,
    required this.products,
  });

  factory Cart.fromMap(Map<String, dynamic> map) {
    try {
      return Cart(
        id: map['_id'] != null ? ObjectId.parse(map['_id']) : null,
        user: map['user'] != null ? ObjectId.parse(map['user']) : null,
        products: List<Map<String, dynamic>>.from(map['products'] ?? []),
      );
    } catch (e) {
      print('Error occurred while parsing Cart from map: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toMap() {
    try {
      return {
        '_id': id,
        'user': user,
        'products': products,
      };
    } catch (e) {
      print('Error occurred while converting Cart to map: $e');
      rethrow;
    }
  }
}
