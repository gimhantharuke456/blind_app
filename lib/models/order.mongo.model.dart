import 'package:mongo_dart/mongo_dart.dart';

class OrderMongoModel {
  ObjectId? id;
  String? userId;
  String? itemName;
  String? description;
  double? price;

  OrderMongoModel({
    this.id,
    required this.userId,
    required this.itemName,
    required this.description,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) '_id': id!,
      'userId': userId!,
      'itemName': itemName!,
      'description': description!,
      'price': price!,
    };
  }

  factory OrderMongoModel.fromMap(Map<String, dynamic> map) {
    return OrderMongoModel(
      id: map['_id'] as ObjectId?,
      userId: map['userId'] as String?,
      itemName: map['itemName'] as String?,
      description: map['description'] as String?,
      price: map['price'] as double?,
    );
  }
}
