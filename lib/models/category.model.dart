import 'package:mongo_dart/mongo_dart.dart';

class Category {
  ObjectId id;
  String name;
  String? description;
  ObjectId? parentCategory;

  Category({
    required this.id,
    required this.name,
    this.description,
    this.parentCategory,
  });

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: ObjectId.parse(map['id'] as String),
      name: map['name'] as String,
      description: map['description'] as String?,
      parentCategory: map['parentCategory'] != null
          ? ObjectId.parse(map['parentCategory'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {
      'id': id,
      'name': name,
      'description': description,
    };
    if (parentCategory != null) {
      map['parentCategory'] = parentCategory!.toHexString();
    }
    return map;
  }
}
