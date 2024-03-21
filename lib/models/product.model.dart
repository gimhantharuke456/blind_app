import 'package:mongo_dart/mongo_dart.dart';

class Product {
  ObjectId id;
  String name;
  String? description;
  ObjectId category;
  double price;
  int stockQuantity;
  List<String>? images;
  String? audioDescriptionUrl;
  List<int>? ratings;
  List<ObjectId>? reviews;

  Product({
    required this.id,
    required this.name,
    this.description,
    required this.category,
    required this.price,
    required this.stockQuantity,
    this.images,
    this.audioDescriptionUrl,
    this.ratings,
    this.reviews,
  });

  // Convert a MongoDB document to a Product object
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['_id'],
      name: map['name'],
      description: map['description'] as String?,
      category: map['category'],
      price: map['price'].toDouble(),
      stockQuantity: map['stockQuantity'],
      images: List<String>.from(map['images'] ?? []),
      audioDescriptionUrl: map['audioDescriptionUrl'] as String?,
      ratings:
          (map['ratings'] as List?)?.map((rating) => rating as int).toList(),
      reviews: (map['reviews'] as List?)
          ?.map((review) => review as ObjectId)
          .toList(),
    );
  }

  // Convert a Product object to a MongoDB document
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'stockQuantity': stockQuantity,
      'images': images,
      'audioDescriptionUrl': audioDescriptionUrl,
      'ratings': ratings,
      'reviews': reviews,
    };
  }
}
